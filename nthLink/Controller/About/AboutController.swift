//
//  AboutController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 5/22/23.
//

import Cocoa

@available(macOS 11.0, *)
class AboutController: AppBaseViewController {
    @IBOutlet private weak var lbVersion: NSTextField!
    @IBOutlet private weak var lbAbout: NSTextField!
    @IBOutlet private weak var menuView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
    }

    override func viewDidAppear() {
       super.viewDidAppear()
    }
    
    
    private func setupInitialData(){
        preferredContentSize = NSSize(width: 420, height: 550)
        self.view.wantsLayer = true
        lbVersion.stringValue = "\(LocalizedStringEnum.about_version.localized) \(Utilities.appVersionNumber ?? 0)"
        lbAbout.attributedStringValue = LocalizedStringEnum.about_text.localized.html2AttributedString ?? NSAttributedString()
        lbAbout.font =  NSFont.systemFont(ofSize: 12)
        setupSideMenuBar()
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 100, height: 550))
        menuBarView.selectedScreen = .About
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
}
