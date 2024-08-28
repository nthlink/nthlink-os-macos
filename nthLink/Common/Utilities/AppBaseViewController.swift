//
//  AppBaseViewController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 17/02/24.
//

import Foundation
import Cocoa

open class AppBaseViewController: NSViewController,NSWindowDelegate,AppBaseHandlable {
     
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewDidAppear() { 
        super.viewDidAppear()
        self.view.window?.delegate = self
        self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
    }
    
    
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: Constants.appBunleId )
        if !runningApps.isEmpty {
            runningApps.last?.hide()
        }
        return false
    }
    
}


protocol AppBaseHandlable {
    func showCommonAlert(message:String)
}

extension AppBaseHandlable {
    
    func showCommonAlert(message:String)  {
        let alert = NSAlert()
        alert.messageText = ""
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: LocalizedStringEnum.OK.localized)
        alert.runModal()
    }
    
}

