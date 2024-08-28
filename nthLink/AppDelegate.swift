import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    func applicationWillFinishLaunching(_ notification: Notification) {
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menuButton = statusItem.button!
        menu.addItem(NSMenuItem(title: "Open nthLink", action: #selector(showApp), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit nthLink", action: #selector(terminateApp), keyEquivalent: ""))
        statusItem.menu = menu
        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        vpnManager.connection.stopVPNTunnel()
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
        vpnManager.connection.stopVPNTunnel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            exit(0)
        })
    }
    
    @objc func showApp(_ sender: Any?) {
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
        vpnManager.connection.stopVPNTunnel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            exit(0)
        })
    }
}

