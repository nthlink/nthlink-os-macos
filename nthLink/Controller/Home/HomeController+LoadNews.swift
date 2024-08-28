//
//  HomeController+LoadNews.swift
//  nthLink
//
//  Created by Vaneet Modgill on 14/04/24.
//

import Cocoa

@available(macOS 11.0, *)
extension HomeController {
    
  
    func getServerConfig() {
        var requstJsonData = Data()
        if let path = Bundle.main.url(forResource: "News", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                requstJsonData = data
            } catch let error{
                print("!!!\(error)")
                
            }
        }
        do {
            let tempNewsData = try? JSONDecoder().decode(NewsData.self, from: requstJsonData)
            let servers = tempNewsData?.servers?.shuffled() ?? []
            for data in servers {
                serverConfig = serverConfig.replacingOccurrences(of: "server_path", with: data.path)
                serverConfig = serverConfig.replacingOccurrences(of: "server_port", with: data.port ?? "")
                serverConfig = serverConfig.replacingOccurrences(of: "server_address", with: data.host)
                serverConfig = serverConfig.replacingOccurrences(of: "server_password", with: data.password ?? "")
                UserDefaults.init(suiteName: appGroup)?.set(serverConfig, forKey: configKey)
            }
            newsData = tempNewsData ?? NewsData()
            newsData?.listData = []
            for data in newsData?.notifications ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 0
                commonData.data = data
                newsData?.listData.append(commonData)
            }
            for data in newsData?.headlineNews ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 1
                commonData.data = data
                newsData?.listData.append(commonData)
            }
            APIDataCacher.sharedInstance.cacheData(forKey: .News, data: newsData as AnyObject)
            try vpnManager.connection.startVPNTunnel()
        } catch let error as NSError  {
            print(error.description)
        }
    }
    
}
