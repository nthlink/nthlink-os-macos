//
//  FollowUsViewController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 12/07/24.
//

import Cocoa
import SwiftUI
class FollowUsViewController: NSViewController {
    @IBOutlet weak var followUSViewBox: NSBox!
    @IBOutlet weak var menuView: NSView!

//    override func loadView() {
//        // Create the SwiftUI view that provides the window contents.
//        let followUsView = FollowUsView()
//        
//        // Create the hosting controller with the SwiftUI view.
//        let hostingController = NSHostingController(rootView: followUsView)
//        
//        // Set the hosting controller's view as the NSViewController's view.
//        self.view = hostingController.view
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
    }

    
    
    private func setupInitialData(){
        preferredContentSize = NSSize(width: 630, height: 825)
        self.view.wantsLayer = true
        setupSideMenuBar()
        let followUsView = FollowUsView()
        
        // Create the hosting controller with the SwiftUI view.
        let hostingController = NSHostingController(rootView: followUsView)
        
        // Set the hosting controller's view as the NSViewController's view.
        self.followUSViewBox.contentView = hostingController.view
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 150, height: 825))
        menuBarView.selectedScreen = .FollowUs
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
