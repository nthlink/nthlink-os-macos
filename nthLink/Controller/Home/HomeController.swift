import Cocoa
import NetworkExtension
import SwiftyJSON
import FlatButton
import Lottie
import WebKit

class HomeController: AppBaseViewController {
    @IBOutlet weak var mainBox: NSBox!
    @IBOutlet weak var landingBox: NSBox!
    @IBOutlet weak var tfName: NSTextField!
    @IBOutlet weak var newsTableView: NSTableView!
    @IBOutlet weak var ivStatus: NSImageView!
    @IBOutlet weak var ivMore: NSImageView!
    @IBOutlet weak var testBox: NSBox!
    @IBOutlet weak var extendWidth: NSLayoutConstraint!
    @IBOutlet weak var frameWidth: NSLayoutConstraint!
    @IBOutlet weak var menuView: NSView!
    @IBOutlet weak var connectView: NSBox!
    @IBOutlet weak var lbConnect: NSTextField!
    @IBOutlet weak var landingPageButton: NSButton!
    @IBOutlet weak var staticValueIndicatorView: NSBox!
    
    private var isExtend = false
    private var vpnStatus:NEVPNStatus = .disconnected


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
        VPNServiceManager.shared.createVPNConfiguration {
            self.updateVpnStatus()
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateVpnStatus), name: NSNotification.Name.NEVPNStatusDidChange, object:  VPNServiceManager.shared.vpnManager.connection)
        }
        if vpnStatus == .connected {
            showStatus(status: .connected)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NEVPNStatusDidChange, object:  VPNServiceManager.shared.vpnManager.connection)
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.delegate = self
        self.view.window?.title = "\(CommonStings.appName) \(Utilities.appVersionNumber ?? "")"
        
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    
    private func setupInitialData() {
        extendWidth.constant = 0
        frameWidth.constant = 480
        preferredContentSize = NSSize(width: 630, height: 825)
        mainBox.layer?.backgroundColor = AppColors.appCreamColor.cgColor
        self.setupSideMenuBar()
    }
    
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 150, height: 825))
        menuBarView.selectedScreen = .Home
        menuBarView.reloadView()
        self.menuView.addSubview(menuBarView)
        menuBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBarView.centerXAnchor.constraint(equalTo: self.menuView.centerXAnchor),
            menuBarView.centerYAnchor.constraint(equalTo: self.menuView.centerYAnchor),
            menuBarView.widthAnchor.constraint(equalToConstant: 150),
            menuBarView.heightAnchor.constraint(equalToConstant: 825)
        ])
    }
    
    @IBAction func tryConnect(_ sender: Any) {
        connectVPN()
    }
    
    @IBAction func goWebsite(_ sender: Any) {
        openLandingPage()
    }
    
    private func openLandingPage() {
        if VPNServiceManager.shared.newsData?.redirectURL == "" {
            return
        }
        let url = URL(string:  VPNServiceManager.shared.newsData?.redirectURL ?? "")!
        if NSWorkspace.shared.open(url) {
            print("Success Load Loadig Page")
            APIDataCacher.sharedInstance.cacheData(forKey: .events, data: [EventModel.createEvent(url: VPNServiceManager.shared.newsData?.redirectURL ?? "", type: .LandingPageOpen)] as AnyObject)
        }
    }
    private func cleanWebViewCookiesAndReloadTable() {
        clearWKWebViewCookies {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
                self.staticValueIndicatorView.isHidden = !(VPNServiceManager.shared.newsData?.static ?? false)
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
    
    
    
    func windowDidBecomeMain(_ notification: Notification) {
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
//            var reportEventsArray = [EventModel]()
//            VPNServiceManager.shared.newsData?.topHeadlineNews.removeAll()
//            for value in randomNumbers {
//                if let tempData = VPNServiceManager.shared.newsData?.headlineNews?[value - 1] {
//                    VPNServiceManager.shared.newsData?.topHeadlineNews.append(tempData)
//                    reportEventsArray.append(EventModel.createEvent(url: tempData.url ?? "", type: .TopHeadlineWebViewCellOpen))
//                }
//            }
            
            
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
    
    @IBAction func connectTrojan(_ sender: Any) {
        connectVPN()
    }
    
    func connectVPN() {
        DispatchQueue.main.async {
            self.showStatus(status: .connecting)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateVpnStatus), name: NSNotification.Name.NEVPNStatusDidChange, object: VPNServiceManager.shared.vpnManager.connection)
        VPNServiceManager.shared.connectVPN { status in
            if status == false {
                DispatchQueue.main.async {
                    self.showStatus(status: .disconnected)
                }
            }
        }
    }

    @objc func updateVpnStatus() {
        vpnStatus = VPNServiceManager.shared.vpnManager.connection.status
        self.showStatus(status: vpnStatus)
    }
    
    
    
    func showStatus(status: NEVPNStatus) {
        menuButton.image = status == .connected ? NSImage(named: AssetImagesString.menuConnected) : NSImage(named: AssetImagesString.menuDisconnected)
        ivStatus.image = status == .connected ? NSImage(named: AssetImagesString.logoWhite) : NSImage(named: AssetImagesString.logoBlue)
        ivMore.isHidden = status == .connected ? false : true
        extendWidth.constant = status == .connected ? 600 : 0
        ivMore.image = status == .connected ? NSImage(named: AssetImagesString.back) : NSImage(named: AssetImagesString.forward)
        testBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        isExtend = status == .connected ?  true : false
        mainBox.fillColor = status == .connected ? AppColors.appBlueColor :  AppColors.appCreamColor
        tfName.textColor = status == .connected ? NSColor.white : NSColor.black
        landingBox.isHidden = true
        landingPageButton.isHidden = status == .connected ?  false : true
        lbConnect.textColor = status == .connected ? NSColor.white : NSColor.black
        lbConnect.textColor = status == .connected ? NSColor.white : NSColor.black
        connectView.borderColor = status == .connected ? NSColor.white : NSColor.black
        if status == .connected {
            // Remove cache
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
            connectView.alphaValue = 1.0
            lbConnect.stringValue = LocalizedStringEnum.Disconnect.localized
            self.cleanWebViewCookiesAndReloadTable()
            if VPNServiceManager.shared.newsData == nil {
                if let tempNewsData = APIDataCacher.sharedInstance.getCacheData(forKey: .News) {
                    VPNServiceManager.shared.newsData = tempNewsData as? NewsData
                    self.cleanWebViewCookiesAndReloadTable()
                }
            }
        } else if status == .connecting {
            connectView.alphaValue = 0.63
            lbConnect.stringValue = LocalizedStringEnum.Connecting.localized
            lbConnect.stringValue = LocalizedStringEnum.Connecting.localized
        } else if status == .invalid ||  status == .reasserting  || status == .disconnected{
            lbConnect.stringValue = LocalizedStringEnum.Connect.localized
            connectView.alphaValue = 1.0
        } else if status == .disconnecting {
            connectView.alphaValue = 0.63
            lbConnect.stringValue = LocalizedStringEnum.Disconnecting.localized
            self.staticValueIndicatorView.isHidden = true
        }
    }
    

    
    @IBAction func showMore(_ sender: Any) {
        extendWidth.constant = isExtend ? 0 : 600
        ivMore.image = isExtend ? NSImage(named: AssetImagesString.forward) : NSImage(named: AssetImagesString.back)
        testBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        isExtend = !isExtend
    }
}


extension HomeController: NSTableViewDataSource {
  
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return VPNServiceManager.shared.newsData?.listData.count ?? 0
    }
    
}

extension HomeController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: NewsCellView.className), owner: self) as! NewsCellView
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
            return 54.0
        } else if news?.type == 1 {
            return 200.0
        } else {
            return 64.0
        }
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        
        let myCustomView = MyCustomView()
        return myCustomView
    }

    
}

