//
//  StatusMenuViewController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 19/05/24.
//

import Cocoa
import NetworkExtension
import WebKit

protocol StatusMenuViewControllerDelegate:AnyObject {
    func statusMenuViewControllerOpenAppButtonPressed(_ statusMenuViewController:StatusMenuViewController)
}

class StatusMenuViewController: AppBaseViewController {

    @IBOutlet weak var vpnStateLabel: NSTextField!
    @IBOutlet weak var connectButton: NSButton!
       @IBOutlet weak var disconnectButton: NSButton!
       @IBOutlet weak var openApp: NSButton!
    @IBOutlet weak var newsTableView: NSTableView!

    @IBOutlet weak var showStatusBarButton: NSButton!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var checkboxIcon: NSImageView!
    private var vpnStatus:NEVPNStatus = .disconnected
    weak var delegate:StatusMenuViewControllerDelegate?

       override func viewDidLoad() {
           super.viewDidLoad()
           NotificationCenter.default.addObserver(self, selector: #selector(self.updateVpnStatus), name: NSNotification.Name.NEVPNStatusDidChange, object:  VPNServiceManager.shared.vpnManager.connection)
       }
    override func viewWillAppear() {
        super.viewDidLoad()
        self.updateVpnStatus()
        
    }

       @IBAction func connectVPN(_ sender: Any) {
           self.connectVPN()
       }

       @IBAction func disconnectVPN(_ sender: Any) {
           self.connectVPN()

       }

       @IBAction func openAppButtonPressed(_ sender: Any) {
           self.delegate?.statusMenuViewControllerOpenAppButtonPressed(self)
       }
    
    @IBAction func reloadNews(_ sender: Any) {
        refreshNews()
    }
    @IBAction func showStatusBarButtonPress(_ sender: Any) {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                  appDelegate.statusItem = nil
            UserDefaults.standard.setValue("0", forKey: UserDefaultKeys.showStatusBarMenu)
              }
        NotificationCenter.default.post(name: Notification.Name(rawValue:NotificationName.showStatusBarMenu), object: nil, userInfo: nil)
    }
    private func connectVPN(){
        if UserDefaults.standard.string(forKey: UserDefaultKeys.isPrivacyPolicyAccepted) != nil {
            VPNServiceManager.shared.connectVPN { status in
                if status == false {
                    DispatchQueue.main.async {
                        self.showStatus(status: .disconnected)
                    }
                }
            }
          return
        }
        showCommonAlert(message:  LocalizedStringEnum.statusBarPrivacyAlert.localized)
    }
    
    
    @objc func updateVpnStatus() {
        vpnStatus = VPNServiceManager.shared.vpnManager.connection.status
        self.showStatus(status: vpnStatus)
    }
    
    
    
    func showStatus(status: NEVPNStatus) {
        menuButton.image = status == .connected ? NSImage(named: AssetImagesString.menuConnected) : NSImage(named: AssetImagesString.menuDisconnected)
        openApp.stringValue = LocalizedStringEnum.statusBarOpenAppText.localized
        openApp.contentTintColor =  NSColor.black
        showStatusBarButton.contentTintColor =  NSColor.black
        connectButton.isEnabled = status != .connected ? true : false
        connectButton.contentTintColor = status != .connected ? NSColor.black : NSColor.darkGray
        disconnectButton.isEnabled = status == .connected ? true : false
        disconnectButton.contentTintColor = status == .connected ? NSColor.black : NSColor.darkGray
        if status == .connected {
            vpnStateLabel.stringValue =  LocalizedStringEnum.statusBarConnectedText.localized
            vpnStateLabel.textColor = AppColors.appBlueColor
            self.cleanWebViewCookiesAndReloadTable()
            if VPNServiceManager.shared.newsData == nil {
                if let tempNewsData = APIDataCacher.sharedInstance.getCacheData(forKey: .News) {
                    VPNServiceManager.shared.newsData = tempNewsData as? NewsData
                    self.cleanWebViewCookiesAndReloadTable()
                }
            }
            mainViewHeightConstraint.constant = 664
        } else if status == .connecting {
            vpnStateLabel.textColor = AppColors.appBlueColor
            vpnStateLabel.stringValue = LocalizedStringEnum.Connecting.localized
            mainViewHeightConstraint.constant = 166
        } else if status == .invalid ||  status == .reasserting  || status == .disconnected{
            vpnStateLabel.stringValue =  LocalizedStringEnum.statusBarNotConnectedText.localized
            vpnStateLabel.textColor = NSColor(red: 229/255, green: 55/255, blue: 55/255, alpha: 1)
            self.cleanWebViewCookiesAndReloadTable()
            mainViewHeightConstraint.constant = 166
        } else if status == .disconnecting {
            vpnStateLabel.stringValue = LocalizedStringEnum.Disconnecting.localized
            vpnStateLabel.textColor = NSColor(red: 229/255, green: 55/255, blue: 55/255, alpha: 1)
            mainViewHeightConstraint.constant = 166
        }
    }
    
    
    
    
    
    
    func refreshNews() {
        if (vpnStatus == .connected) {
            if (VPNServiceManager.shared.newsData?.headlineNews?.count ?? 0) <= 3 {
                return
            }
            var reportEventsArray = [EventModel]()

//            var pinToTopIndex = VPNServiceManager.shared.newsData?.headlineNews?.firstIndex(where: {$0.pinToTop == true})
//            if pinToTopIndex != nil {
//                pinToTopIndex! += 1
//            }
//            
//            guard let randomNumbers = VPNServiceManager.shared.generateUniqueRandomNumbers(count: 4, min: 1, max: VPNServiceManager.shared.newsData?.headlineNews?.count ?? 0,customNumber: pinToTopIndex) else {
//                return
//            }
//            VPNServiceManager.shared.newsData?.topHeadlineNews.removeAll()
//            for value in randomNumbers {
//                if let tempData = VPNServiceManager.shared.newsData?.headlineNews?[value - 1] {
//                    VPNServiceManager.shared.newsData?.topHeadlineNews.append(tempData)
//                    reportEventsArray.append(EventModel.createEvent(url: tempData.url ?? "", type: .TopHeadlineWebViewCellOpen))
//                }
//            }
            
            // Determine the number of top news items to show (maximum 4 or less if there aren't enough)
            let totalHeadlineCount = VPNServiceManager.shared.newsData?.headlineNews?.count ?? 0
            let topNewsCount = min(4, totalHeadlineCount)
            
            // Separate pinned and non-pinned news items
            let pinnedNews = VPNServiceManager.shared.newsData?.headlineNews?.filter { $0.pinToTop == true } ?? []
            let nonPinnedNews = VPNServiceManager.shared.newsData?.headlineNews?.filter { $0.pinToTop != true } ?? []
            
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
                        if let randomIndices = VPNServiceManager.shared.generateUniqueRandomNumbers(count: remainingCount, min: 0, max: nonPinnedNews.count - 1, customNumber: nil) {
                            for index in randomIndices {
                                topHeadlineNews.append(nonPinnedNews[index])
                                    reportEventsArray.append(EventModel.createEvent(url: nonPinnedNews[index].url ?? "", type: .TopHeadlineWebViewCellOpen))

                            }
                        }
                    } else if remainingCount > 0 {
                        // If there are fewer non-pinned items than needed, add all
                        topHeadlineNews.append(contentsOf: nonPinnedNews)
                    }
                }
            } else {
                // No pinned news available; randomly select from all headline news
                if let randomIndices = VPNServiceManager.shared.generateUniqueRandomNumbers(count: topNewsCount, min: 0, max: totalHeadlineCount - 1, customNumber: nil) {
                    for index in randomIndices {
                        if let newsItem = VPNServiceManager.shared.newsData?.headlineNews?[index] {
                            topHeadlineNews.append(newsItem)
                        }
                    }
                }
            }
            
            
            
            VPNServiceManager.shared.newsData?.listData = []
            for data in VPNServiceManager.shared.newsData?.notifications ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 0
                commonData.data = data
                VPNServiceManager.shared.newsData?.listData.append(commonData)
            }
            for data in VPNServiceManager.shared.newsData?.topHeadlineNews ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 1
                commonData.data = data
                VPNServiceManager.shared.newsData?.listData.append(commonData)
            }
            for data in VPNServiceManager.shared.newsData?.headlineNews ?? [] {
                let commonData = CommonNewsData()
                commonData.type = 2
                commonData.data = data
                VPNServiceManager.shared.newsData?.listData.append(commonData)
            }
            self.cleanWebViewCookiesAndReloadTable()
            APIDataCacher.sharedInstance.cacheData(forKey: .events, data: reportEventsArray as AnyObject)
        }
    }
    
    private func cleanWebViewCookiesAndReloadTable() {
        clearWKWebViewCookies {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
    
    
    func clearWKWebViewCookies(completion: @escaping () -> Void) {
        let dataTypes = Set([WKWebsiteDataTypeCookies])
        let dateFrom = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: dateFrom) {
            print("WKWebView cookies cleared.")
            completion()
        }
    }
    

    
}


extension StatusMenuViewController: NSTableViewDataSource {
  
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return vpnStatus != .connected ? 0 : VPNServiceManager.shared.newsData?.listData.count ?? 0
    }
    
}

extension StatusMenuViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: StatusBarNewsCellView.className), owner: self) as! StatusBarNewsCellView
        cellView.set(news: VPNServiceManager.shared.newsData?.listData[row] ?? CommonNewsData(), index: row)
        cellView.webview.tableView = tableView
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedIndex = newsTableView.selectedRow
        self.cleanWebViewCookiesAndReloadTable()
        let tempData = VPNServiceManager.shared.newsData?.listData[selectedIndex].data.url ?? ""
        let url = URL(string: tempData)!
        NSWorkspace.shared.open(url)
        APIDataCacher.sharedInstance.cacheData(forKey: .events, data: [EventModel.createEvent(url: tempData, type: .ClickOnNewsHeadline)] as AnyObject)
    }
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let news = VPNServiceManager.shared.newsData?.listData[row]
        if news?.type == 0 {
            return CGFloat.leastNonzeroMagnitude
        } else if news?.type == 1 {
            return 120.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        
        let myCustomView = MyCustomView()
        return myCustomView
    }

    
}

