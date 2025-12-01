import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem:NSStatusItem?
    var popover: NSPopover!
    var customViewController: StatusMenuViewController!
    var eventMonitor: Any?

    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.setupStatusBar()

        setupMenuBar()

        setupSignalHandler()

        
    }
    
    func setupStatusBar() {
        var isShowStatusBar = "1"
        if let valueIsShowStatusBar = UserDefaults.standard.string(forKey: UserDefaultKeys.showStatusBarMenu)  {
            isShowStatusBar = valueIsShowStatusBar
            }
        if isShowStatusBar == "0" {return}
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        menuButton = statusItem!.button!
        
        if let button = statusItem!.button {
            button.action = #selector(togglePopover(_:))
        }
        customViewController = StatusMenuViewController(nibName: "StatusMenuViewController", bundle: nil)
        customViewController.delegate = self
        popover = NSPopover()
        popover.contentViewController = customViewController
        popover.behavior = .transient
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            self?.closePopover(event)
        }
        
    }
    
    
    @objc func togglePopover(_ sender: Any?) {
        if let button = statusItem?.button {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
    }
    
    func showPopover(_ sender: Any?) {
        if let button = statusItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    func closePopover(_ sender: Any?) {
        popover.performClose(sender)
    }
    
    func setupMenuBar() {
        let mainMenu = NSMenu()
        NSApp.mainMenu = mainMenu
        
        let nthLinkMenuItem = NSMenuItem(title: CommonStings.appName, action: nil, keyEquivalent: "")
        mainMenu.addItem(nthLinkMenuItem)
        
        let nthLinkMenu = NSMenu(title: CommonStings.appName)
        nthLinkMenuItem.submenu = nthLinkMenu
        
        nthLinkMenu.addItem(withTitle: "\(LocalizedStringEnum.About.localized) \(CommonStings.appName)", action: #selector(showAbout), keyEquivalent: "")
        nthLinkMenu.addItem(NSMenuItem.separator())
        nthLinkMenu.addItem(withTitle: "nthLink.com", action: #selector(shownthLinkWebPage), keyEquivalent: "")
        nthLinkMenu.addItem(NSMenuItem.separator())
        nthLinkMenu.addItem(withTitle: "\(LocalizedStringEnum.menuBarHideText.localized) \(CommonStings.appName)", action: #selector(hidenthLink), keyEquivalent: "h")
        nthLinkMenu.addItem(withTitle: LocalizedStringEnum.menuBarHideOthersText.localized, action: #selector(hideOthers), keyEquivalent: "h")
        nthLinkMenu.addItem(withTitle: LocalizedStringEnum.menuBarShowAllext.localized, action: #selector(unhideAllApplications), keyEquivalent: "")
        nthLinkMenu.addItem(NSMenuItem.separator())
        nthLinkMenu.addItem(withTitle: "\(LocalizedStringEnum.menuBarQuitText.localized) \(CommonStings.appName)", action: #selector(terminate), keyEquivalent: "q")
    }
    
    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = CommonStings.appName
        alert.informativeText = "\(LocalizedStringEnum.about_version.localized) \(Utilities.appVersionNumber ?? 0)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: LocalizedStringEnum.OK.localized)
        alert.runModal()
    }
    
    @objc func hidenthLink() {
        NSApp.hide(nil)
    }
    
    @objc func hideOthers() {
        NSApp.hideOtherApplications(nil)
    }
    
    @objc func unhideAllApplications() {
        NSApp.unhideAllApplications(nil)
    }
    @objc func shownthLinkWebPage() {
        let url = URL(string: AppConfigurations.getHomeURL())!
        NSWorkspace.shared.open(url)
    }
    
    @objc func terminate() {
        VPNServiceManager.shared.vpnManager.connection.stopVPNTunnel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            NSApp.terminate(nil)
        })
    }
  
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        VPNServiceManager.shared.vpnManager.connection.stopVPNTunnel()
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }

    func setupSignalHandler() {
         signal(SIGTERM) { signal in
             VPNServiceManager.shared.vpnManager.connection.stopVPNTunnel()
             exit(signal)
         }

         signal(SIGINT) { signal in
             VPNServiceManager.shared.vpnManager.connection.stopVPNTunnel()
             exit(signal)
         }
     }
    
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if let window = NSApp.windows.last{
            if !window.isVisible{
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }
    
    
    @IBAction func quitApp(_ sender: Any) {
        VPNServiceManager.shared.vpnManager.connection.stopVPNTunnel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            exit(0)
        })
    }
    
     func showApp() {
        // Replace "com.example.yourapp" with the bundle identifier of the app you want to show
        if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: Constants.appBunleId) {
            do {
                try NSWorkspace.shared.launchApplication(at: appURL, options: .default, configuration: [:])
            } catch {
                print("Error: \(error.localizedDescription)")
                if let window = NSApp.windows.first{
                    NSApp.activate(ignoringOtherApps: true)
                    window.makeKeyAndOrderFront(self)
                }
            }
        } else {
            print("App not found.")
            if let window = NSApp.windows.first{
                NSApp.activate(ignoringOtherApps: true)
                window.setIsVisible(true)
                window.makeKeyAndOrderFront(self)
            }
        }
    }
    
    
    @objc func connectVPN() {
        if let window = NSApp.windows.first{
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(self)
        }
        showDock(state: true)
    }
    
    @objc func terminateApp() {
        VPNServiceManager.shared.vpnManager.connection.stopVPNTunnel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            exit(0)
        })
    }
}

extension AppDelegate : StatusMenuViewControllerDelegate {
    func statusMenuViewControllerOpenAppButtonPressed(_ statusMenuViewController:StatusMenuViewController){
        self.showApp()
    }
}

