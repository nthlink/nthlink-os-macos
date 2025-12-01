//
//  DiagnosticsViewController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 03/12/24.
//

import Foundation
import Cocoa
import SwiftyJSON
import Network

class DiagnosticsViewController: AppBaseViewController {
    @IBOutlet private weak var loadingView: NSBox!
    @IBOutlet private weak var menuView: NSView!
    @IBOutlet private weak var activityIndicator: NSProgressIndicator!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    
    private func setupInitialData(){
        let _ = VPNServiceManager.shared.isReachable
        loadingView.isHidden = true
        preferredContentSize = NSSize(width: 630, height: 825)
        self.view.wantsLayer = true
        setupSideMenuBar()
    }
    @IBAction func startDiagnostics(_ sender: Any) {
        if !VPNServiceManager.shared.isReachable {
            self.showCommonAlert(message:  LocalizedStringEnum.diagnosticsInternetError.localized)
            return
        }
        if VPNServiceManager.shared.vpnManager.connection.status == .connected {
            let alert = NSAlert()
            alert.messageText =  LocalizedStringEnum.diagnosticsStartDisconnectWarning.localized
            alert.addButton(withTitle: LocalizedStringEnum.OK.localized)
            alert.addButton(withTitle: LocalizedStringEnum.Cancel.localized)
            if alert.runModal() == .alertFirstButtonReturn {
                self.showActivityLoader()
                VPNServiceManager.shared.disconnectVPN()
                DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                    self.sendDiagnostics()
                })
            }
            return
        }
        self.showActivityLoader()
        self.sendDiagnostics()
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 150, height: 825))
        menuBarView.selectedScreen = .Diagnostics
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
    
    
    func sendDiagnostics() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideActivityLoader()
            self.showCommonAlert(message: LocalizedStringEnum.diagnosticsSuceessMessage.localized)
        }
    }
    
    
    func getCarrierName() -> String {
        return ""
    }
    
    func getNetworkType() -> String {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        var networkType = "OTHER" // Default to OTHER
        
        let semaphore = DispatchSemaphore(value: 0) // To wait for the result
        
        monitor.pathUpdateHandler = { path in
            if path.usesInterfaceType(.wifi) {
                networkType = "WIFI"
            } else if path.usesInterfaceType(.wiredEthernet) {
                networkType = "ETHERNET"
            } else if path.usesInterfaceType(.cellular) {
                networkType = "CELLULAR"
            } else {
                networkType = "OTHER"
            }
            semaphore.signal()
        }
        
        monitor.start(queue: queue)
        semaphore.wait()
        monitor.cancel()
        
        return networkType
    }
    
    private func showActivityLoader() {
        loadingView.isHidden = false
        activityIndicator.style = .spinning
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.startAnimation(nil)
    }
    
    private func hideActivityLoader() {
        loadingView.isHidden = true
        activityIndicator?.stopAnimation(nil)
    }
    
    
}
