import Cocoa
import NetworkExtension
import SwiftyJSON
import FlatButton
import Lottie

@available(macOS 11.0, *)
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
    
    private var isExtend = false
    private var vpnStatus:NEVPNStatus = .disconnected
    var newsData:NewsData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
        createVPNConfiguration()
        if vpnStatus == .connected {
            showStatus(status: .connected)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NEVPNStatusDidChange, object: vpnManager.connection)
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
        frameWidth.constant = 320
        preferredContentSize = NSSize(width: 420, height: 550)
        mainBox.layer?.backgroundColor = AppColors.appCreamColor.cgColor
        self.setupSideMenuBar()
    }
    
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 100, height: 550))
        menuBarView.selectedScreen = .Home
        menuBarView.reloadView()
        self.menuView.addSubview(menuBarView)
        menuBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBarView.centerXAnchor.constraint(equalTo: self.menuView.centerXAnchor),
            menuBarView.centerYAnchor.constraint(equalTo: self.menuView.centerYAnchor),
            menuBarView.widthAnchor.constraint(equalToConstant: 100),
            menuBarView.heightAnchor.constraint(equalToConstant: 550)
        ])
    }
    
    @IBAction func tryConnect(_ sender: Any) {
        connectVPN()
    }
    
    @IBAction func goWebsite(_ sender: Any) {
        if self.newsData?.redirectURL == "" {
            return
        }
        let url = URL(string:  self.newsData?.redirectURL ?? "")!
        if NSWorkspace.shared.open(url) {
            print("Success Load Loadig Page")
        }
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        if (vpnStatus == .connected) {
            newsTableView.reloadData()
        }
    }
    
    @IBAction func connectTrojan(_ sender: Any) {
        connectVPN()
    }

    @objc func updateVpnStatus() {
        vpnStatus = vpnManager.connection.status
        self.showStatus(status: vpnStatus)
    }
    
    
    
    func showStatus(status: NEVPNStatus) {
        menuButton.image = status == .connected ? NSImage(named: AssetImagesString.menuConnected) : NSImage(named: AssetImagesString.menuDisconnected)
        ivStatus.image = status == .connected ? NSImage(named: AssetImagesString.logoWhite) : NSImage(named: AssetImagesString.logoBlue)
        ivMore.isHidden = status == .connected ? false : true
        extendWidth.constant = status == .connected ? 400 : 0
        ivMore.image = status == .connected ? NSImage(named: AssetImagesString.back) : NSImage(named: AssetImagesString.forward)
        testBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        isExtend = status == .connected ?  true : false
        mainBox.fillColor = status == .connected ? AppColors.appBlueColor :  AppColors.appCreamColor
        tfName.textColor = status == .connected ? NSColor.white : NSColor.black
        landingBox.isHidden = status == .connected ? false : true
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
            newsTableView.reloadData()
            if newsData == nil {
                if let tempNewsData = APIDataCacher.sharedInstance.getCacheData(forKey: .News) {
                    self.newsData = tempNewsData as? NewsData
                    self.newsTableView.reloadData()
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
        }
    }
    

    
    @IBAction func showMore(_ sender: Any) {
        extendWidth.constant = isExtend ? 0 : 400
        ivMore.image = isExtend ? NSImage(named: AssetImagesString.forward) : NSImage(named: AssetImagesString.back)
        testBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        isExtend = !isExtend
    }
}


@available(macOS 11.0, *)
extension HomeController: NSTableViewDataSource {
  
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return newsData?.listData.count ?? 0
    }
    
}

@available(macOS 11.0, *)
extension HomeController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: NewsCellView.className), owner: self) as! NewsCellView
        cellView.set(news: newsData?.listData[row] ?? CommonNewsData(), index: row)
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedIndex = newsTableView.selectedRow
        newsTableView.reloadData()
        let url = URL(string: newsData?.listData[selectedIndex].data.url ?? "")!
        NSWorkspace.shared.open(url)
    }
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let news = newsData?.listData[row]
        if news?.type == 0 {
            return 45.0
        } else {
            return 55.0
        }
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let myCustomView = MyCustomView()
        return myCustomView
    }

    
}
