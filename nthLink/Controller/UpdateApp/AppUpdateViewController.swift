//
//  AppUpdateViewController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 26/12/24.
//

import Cocoa

class AppUpdateViewController: AppBaseViewController {
    @IBOutlet private weak var menuView: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
    }
    
    
    
    private func setupInitialData(){
        setupSideMenuBar()
    }
    
    @IBAction func updateAppButtonPressed(_ sender: Any) {
        let url = URL(string: AppConfigurations.getAppStoreURLForUpdate())!
        NSWorkspace.shared.open(url)
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 150, height: 825))
        menuBarView.selectedScreen = .UpdateApp
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
