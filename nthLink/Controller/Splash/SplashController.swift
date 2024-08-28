//
//  SplashController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 5/22/23.
//

import Cocoa
import SwiftyJSON

@available(macOS 11.0, *)
class SplashController: AppBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = NSSize(width: 420, height: 550)
        // Do view setup here.
        self.setupInitialData()
   
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "\(CommonStings.appName) \(Utilities.appVersionNumber ?? "")"
    }
    
    private func setupInitialData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if UserDefaults.standard.string(forKey: UserDefaultKeys.isPrivacyPolicyAccepted) != nil{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let newViewController = NSStoryboard.loadHomeViewController()
                    self.view.window?.contentViewController = newViewController
                }
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let privacyController = NSStoryboard.loadPrivacyController()
                self.view.window?.contentViewController = privacyController
                
            }
        })
    }

}
