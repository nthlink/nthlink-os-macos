//
//  PrivacyController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 5/22/23.
//

import Cocoa

@available(macOS 11.0, *)
class PrivacyController: AppBaseViewController {
    @IBOutlet weak private var tfTerms1: NSTextField!
    @IBOutlet weak private var tfTerms2: NSTextField!
    @IBOutlet weak private var tfTerms3: NSTextField!
    @IBOutlet weak private var tfTerms4: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = NSSize(width: 420, height: 550)
        self.setupPrivacyTextView()
    }
    
    
    private func setupPrivacyTextView() {
        tfTerms1.attributedStringValue = NSMutableAttributedString()
            .bold("License. ")
            .normal("nthLink is made available by nthLink under the Apache 2.0 license.")
        tfTerms2.attributedStringValue = NSMutableAttributedString()
            .bold("Assumption of Risk. ")
            .normal("You may use nthLink and invite others to use nthLink only as permitted by law. We encourage you to check local laws and regulations before using nthLink.")
        tfTerms3.attributedStringValue = NSMutableAttributedString()
            .bold("Your content. ")
            .normal("Content that you upload, submit, store, send or receive through nthLink Servers (“Your Content”) is not uploaded or submitted to nthLink. We do not know what you are sending with nthLink.")
        tfTerms4.attributedStringValue = NSMutableAttributedString()
            .bold("Copyright notices. ")
            .normal("nthLink does not host or store any content that you access through nthLink Servers. Any notices of alleged copyright infringement or other legal notices relating to content hosted, stored, sent or received via nthLink Servers should be dealt with by you or directed to your Service Provider.")
    }
    
    @IBAction func goToMain(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: UserDefaultKeys.isPrivacyPolicyAccepted)
        let newViewController = NSStoryboard.loadHomeViewController()
        self.view.window?.contentViewController = newViewController
    }
    
    @IBAction func goToAbout(_ sender: Any) {
        let url = URL(string: AppConfigurations.getHomeURL())!
        NSWorkspace.shared.open(url)
    }
    
 
}
