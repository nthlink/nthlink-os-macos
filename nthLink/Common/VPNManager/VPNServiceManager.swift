//
//  VPNServiceManager.swift
//  nthLink
//
//  Created by Vaneet Modgill on 22/05/24.
//

import Foundation
import NetworkExtension
import SwiftyJSON
import Network

class VPNServiceManager: NSObject {
    
    static let shared = VPNServiceManager()
    var vpnManager = NEVPNManager.shared()
    var newsData:NewsData?
    var isReachable = true
    let monitor = NWPathMonitor()
    //#MARK: Server settings
    
    
    
    
    private override init() {
        super.init()
        self.startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isReachable = true
            } else {
                self?.isReachable = false
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    
    func createVPNConfiguration (completionHandler: @escaping () -> Void) {
        loadOrCreateVPNManager(completionHandler: { error in
            guard error == nil else {
                print("Unable to load or create VPN manager: \(String(describing: error))")
                return
            }
            completionHandler()
        })
    }
    
    
    func loadOrCreateVPNManager(completionHandler: @escaping (Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences(completionHandler: { managers, error in
            guard let managers = managers, error == nil else {
                completionHandler(error)
                return
            }
            if managers.count > 0 {
                self.vpnManager = managers[0]
            } else {
                let manager = NETunnelProviderManager()
                manager.protocolConfiguration = NETunnelProviderProtocol()
                manager.localizedDescription = VPNConstants.localizedDescription
                manager.protocolConfiguration?.serverAddress = VPNConstants.serverAddress
                manager.saveToPreferences { error in
                    guard error == nil else {
                        completionHandler(error)
                        return
                    }
                    manager.loadFromPreferences { error in
                        self.vpnManager = manager
                    }
                }
            }
            completionHandler(nil)
        })
    }
    
    
    
    func disconnectVPN() {
        vpnManager.connection.stopVPNTunnel()
    }
    
    
    func connectVPN(completionHandler: @escaping (Bool) -> Void) {
        vpnManager.isEnabled = true
        vpnManager.saveToPreferences { error in
            guard error == nil else {
                print("Unable to save VPN configuration: \(String(describing: error))")
                return
            }
            self.vpnManager.loadFromPreferences { error in
                guard error == nil else {
                    print("Unable to load VPN configuration: \(String(describing: error))")
                    return
                }
                switch self.vpnManager.connection.status {
                case .disconnected, .invalid:
                    self.getServerConfig { status in
                        completionHandler(status)
                    }
                default:
                    completionHandler(false)
                    self.disconnectVPN()
                }
            }
        }
    }
    
    func getServerConfig(completionHandler: @escaping (Bool) -> Void) {
        guard let path = Bundle.main.url(forResource: "News", withExtension: "json") else {
            self.disconnectVPN()
            let alert = NSAlert()
            alert.messageText = ""
            alert.informativeText = LocalizedStringEnum.somethingWentWrong.localized
            alert.alertStyle = .warning
            alert.addButton(withTitle: LocalizedStringEnum.OK.localized)
            alert.runModal()
            completionHandler(false)
            print("News.json file not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: path)
            let tempNewsData = try? JSONDecoder().decode(NewsData.self, from: data)
            newsData = tempNewsData
            completionHandler(true)
            if tempNewsData?.use_custom_config ?? false{
                let config = """
                             [General]
                             tun-fd = {{TUN-FD}}
                             
                             """
                let customConfig = tempNewsData?.custom_config?.replacingOccurrences(of: "[General]\n", with: config)
                UserDefaults.init(suiteName: appGroup)?.set(customConfig, forKey: configKey)
            } else {
                for i in tempNewsData?.servers ?? [] {
                    if  !i.ips.isEmpty {
                        let ipsList = i.ips.joined(separator: ", ")
                        let wsHost = i.wsHost.isEmpty == false ? i.wsHost : i.host
                        let ips = "ips = \(ipsList)"
                        let serverConf = "Proxy = trojan, ips, \(String(i.port)), password=\(i.password), sni=\(i.host), ws=true, ws-path=\(i.path), ws-host=\(wsHost)"
                        let newConf = config + serverConf  + "\n" + "[Host]\n" + ips
                        UserDefaults.init(suiteName: appGroup)?.set(newConf, forKey: configKey)
                    } else {
                        let wsHost = i.wsHost.isEmpty == false ? i.wsHost : i.host
                        let serverConf = "Proxy = trojan, \(i.address), \(String(i.port)), password=\(i.password), sni=\(i.host), ws=true, ws-path=\(i.path), ws-host=\(wsHost)"
                        let newConf = config + serverConf
                        UserDefaults.init(suiteName: appGroup)?.set(newConf, forKey: configKey)
                    }
                }
            }
            // Determine the number of top news items to show (maximum 4 or less if there aren't enough)
            let totalHeadlineCount = newsData?.headlineNews?.count ?? 0
            let topNewsCount = min(4, totalHeadlineCount)
            
            // Separate pinned and non-pinned news items
            let pinnedNews = newsData?.headlineNews?.filter { $0.pinToTop == true } ?? []
            let nonPinnedNews = newsData?.headlineNews?.filter { $0.pinToTop != true } ?? []
            
            var topHeadlineNews = [HeadlineNewsData]()
            
            // 1. Add pinned news to the top list.
            if !pinnedNews.isEmpty {
                if pinnedNews.count >= topNewsCount {
                    topHeadlineNews.append(contentsOf: Array(pinnedNews.prefix(topNewsCount)))
                } else {
                    topHeadlineNews.append(contentsOf: pinnedNews)
                    let remainingCount = topNewsCount - pinnedNews.count
                    
                    // 2. Randomly select additional news from non-pinned items if needed.
                    if remainingCount > 0 && nonPinnedNews.count >= remainingCount {
                        if let randomIndices = generateUniqueRandomNumbers(count: remainingCount, min: 0, max: nonPinnedNews.count - 1, customNumber: nil) {
                            for index in randomIndices {
                                topHeadlineNews.append(nonPinnedNews[index])
                            }
                        }
                    } else if remainingCount > 0 {
                        // If there are fewer non-pinned items than needed, add all
                        topHeadlineNews.append(contentsOf: nonPinnedNews)
                    }
                }
            } else {
                // No pinned news available; randomly select from all headline news
                if let randomIndices = generateUniqueRandomNumbers(count: topNewsCount, min: 0, max: totalHeadlineCount - 1, customNumber: nil) {
                    for index in randomIndices {
                        if let newsItem = newsData?.headlineNews?[index] {
                            topHeadlineNews.append(newsItem)
                        }
                    }
                }
            }
            
            // Update the newsData with the selected top headline news
            newsData?.topHeadlineNews = topHeadlineNews
            
            
            newsData?.listData = []
            for data in newsData?.notifications ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 0
                commonData.data = data
                newsData?.listData.append(commonData)
            }
            for data in newsData?.topHeadlineNews ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 1
                commonData.data = data
                newsData?.listData.append(commonData)
            }
            for data in newsData?.headlineNews ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 2
                commonData.data = data
                newsData?.listData.append(commonData)
            }
            self.openLandingPage()
            APIDataCacher.sharedInstance.cacheData(forKey: .News, data: newsData as AnyObject)
            try vpnManager.connection.startVPNTunnel()
        } catch let error as NSError  {
            print(error.description)
            completionHandler(false)
        }
    }
    
    func generateUniqueRandomNumbers(count: Int, min: Int, max: Int, customNumber: Int?) -> [Int]? {
        guard max - min + 1 >= count else {
            return nil
        }
        
        var numbers = Set<Int>()
        
        // If a custom number is provided and within the range, add it.
        if let custom = customNumber, custom >= min, custom <= max {
            numbers.insert(custom)
        }
        
        // Generate random numbers until the set reaches the desired count.
        while numbers.count < count {
            let randomNumber = Int.random(in: min...max)
            numbers.insert(randomNumber)
        }
        
        // If a custom number was provided, ensure it is at the first index.
        var result = Array(numbers)
        if let custom = customNumber, custom >= min, custom <= max {
            result.removeAll { $0 == custom }
            result.insert(custom, at: 0)
        }
        
        return result
    }
    
    
    private func openLandingPage() {
        if VPNServiceManager.shared.newsData?.redirectURL == "" {
            return
        }
        let url = URL(string:  VPNServiceManager.shared.newsData?.redirectURL ?? "")!
        if NSWorkspace.shared.open(url) {
            print("Success Load Landing Page")
        }
    }
    
    
}

