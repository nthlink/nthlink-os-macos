//
//  SettingsViewController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 24/05/24.
//
import Cocoa

class SettingsViewController: AppBaseViewController {
    @IBOutlet private weak var menuView: NSView!
    
    @IBOutlet weak var checkBoxButton: NSButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateStatus), name: NSNotification.Name(rawValue: NotificationName.showStatusBarMenu), object: nil)
    }

    override func viewDidAppear() {
       super.viewDidAppear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: NotificationName.showStatusBarMenu), object: nil)

    }
    
    @IBAction func checkBoxPressed(_ sender: Any) {
        UserDefaults.standard.setValue(checkBoxButton.state, forKey: UserDefaultKeys.showStatusBarMenu)
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            if checkBoxButton.state == .off {
                appDelegate.statusItem = nil
            } else {
                appDelegate.setupStatusBar()
                menuButton.image = VPNServiceManager.shared.vpnManager.connection.status == .connected ? NSImage(named: AssetImagesString.menuConnected) : NSImage(named: AssetImagesString.menuDisconnected)

            }
        }
        
    }
    
    @objc func updateStatus() {
        updateCheckBox()
    }
    
    private func updateCheckBox(){
        var isShowStatusBar = "1"
        if let valueIsShowStatusBar = UserDefaults.standard.string(forKey: UserDefaultKeys.showStatusBarMenu)  {
            isShowStatusBar = valueIsShowStatusBar
            }
        checkBoxButton.state = isShowStatusBar == "1" ? .on : .off
    }
    
    
    private func setupInitialData(){
        preferredContentSize = NSSize(width: 630, height: 825)
        self.view.wantsLayer = true
 
        setupSideMenuBar()
        updateCheckBox()
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 150, height: 825))
        menuBarView.selectedScreen = .Settings
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

}
