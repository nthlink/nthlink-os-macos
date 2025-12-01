//
//  MenuBarView.swift
//  nthLink
//
//  Created by Vaneet Modgill on 13/04/24.
//

import Cocoa

enum MenuBarSelectedScreen {
    case Home
    case Feedback
    case About
    case Settings
    case FollowUs
    case Diagnostics
    case UpdateApp
}

class MenuBarView: NSView {
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var homeBox: NSBox!
    @IBOutlet weak var aboutBox: NSBox!
    @IBOutlet weak var privacyPolicyBox: NSBox!
    @IBOutlet weak var helpBox: NSBox!
    @IBOutlet weak var rateBox: NSBox!
    @IBOutlet weak var feedbackBox: NSBox!
    @IBOutlet weak var settingsBox: NSBox!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var followUsBox: NSBox!
    @IBOutlet weak var diagnosticsBox: NSBox!
    @IBOutlet weak var updateAppBox: NSBox!

    
    var selectedScreen:MenuBarSelectedScreen = .Home
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        wantsLayer = true
        canDrawSubviewsIntoLayer = true
        setup()
    }
    
    private func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: .init(String(describing: type(of: self))), bundle: bundle)!
        _ = nib.instantiate(withOwner: self, topLevelObjects: nil)
        
        let contentConstraints = contentView.constraints
        contentView.subviews.forEach({ addSubview($0) })
        
        for constraint in contentConstraints {
            let firstItem = (constraint.firstItem as? NSView == contentView) ? self : constraint.firstItem
            let secondItem = (constraint.secondItem as? NSView == contentView) ? self : constraint.secondItem
            addConstraint(NSLayoutConstraint(item: firstItem as Any, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
        }
        reloadView()
    }
    
    
    func reloadView() {
        setArea(name: BoxNames.homeBox, obj: homeBox)
        setArea(name:  BoxNames.feedbackBox, obj: feedbackBox)
        setArea(name: BoxNames.aboutBox, obj: aboutBox)
        setArea(name: BoxNames.settingsBox, obj: settingsBox)
        setArea(name: BoxNames.privacyPolicyBox, obj: privacyPolicyBox)
        setArea(name: BoxNames.helpBox, obj: helpBox)
        setArea(name: BoxNames.rateBox, obj: rateBox)
        setArea(name: BoxNames.followUsBox, obj: followUsBox)
        setArea(name: BoxNames.diagnosticsBox, obj: diagnosticsBox)
        setArea(name: BoxNames.updateAppBox, obj: updateAppBox)
        versionLabel.stringValue = "\(LocalizedStringEnum.about_version.localized) \(Utilities.appVersionNumber ?? 0)"
        self.setBackgroundColour()
        self.checkUpdateAppData()
    }
    
    private func checkUpdateAppData(){
        updateAppBox.isHidden = true
        guard let newsData = APIDataCacher.sharedInstance.getCacheData(forKey: .News) as? NewsData else { return }
        if newsData.currentVersions.count == 0 {return}
        let filterPlatformData = newsData.currentVersions[0].platforms.filter{$0.os == "macos"}
        if filterPlatformData.isEmpty {return}
        let appVersionFromAPI = (filterPlatformData.first?.version ?? "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")
        let appVersion = (Utilities.appVersionNumber as? String ?? "").replacingOccurrences(of: ".", with: "")
        if appVersion < appVersionFromAPI {
            updateAppBox.isHidden = false
        }
    }
    
    private func setBackgroundColour() {
        homeBox.fillColor = NSColor.white
        feedbackBox.fillColor = NSColor.white
        aboutBox.fillColor = NSColor.white
        diagnosticsBox.fillColor = NSColor.white
        updateAppBox.fillColor = NSColor.white
        switch selectedScreen {
        case .Home:
            homeBox.fillColor = AppColors.appCreamColor
        case .Feedback:
            feedbackBox.fillColor = AppColors.appCreamColor
        case .About:
            aboutBox.fillColor = AppColors.appCreamColor
        case .Settings:
            settingsBox.fillColor = AppColors.appCreamColor
        case .FollowUs:
            followUsBox.fillColor = AppColors.appCreamColor
        case .Diagnostics:
            diagnosticsBox.fillColor = AppColors.appCreamColor
        case .UpdateApp:
            updateAppBox.fillColor = AppColors.appCreamColor
            
        }
    }
    
    
    
    
    
    
    override func mouseEntered(with event: NSEvent) {
        if let buttonName = event.trackingArea?.userInfo?.values.first as? String {
            switch(buttonName) {
            case  BoxNames.homeBox:
                if selectedScreen == .Home { break }
                homeBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.aboutBox:
                if selectedScreen == .About { break }
                aboutBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.privacyPolicyBox:
                privacyPolicyBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.helpBox:
                helpBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.rateBox:
                rateBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.feedbackBox:
                if selectedScreen == .Feedback { break }
                feedbackBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.settingsBox:
                if selectedScreen == .Settings { break }
                settingsBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.diagnosticsBox:
                if selectedScreen == .Diagnostics { break }
                diagnosticsBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.followUsBox:
                if selectedScreen == .FollowUs { break }
                followUsBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            case BoxNames.updateAppBox:
                if selectedScreen == .UpdateApp { break }
                updateAppBox.fillColor = AppColors.appCreamColor
                NSCursor.pointingHand.set()
                break
            default:
                NSCursor.pointingHand.set()
            }
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        if let buttonName = event.trackingArea?.userInfo?.values.first as? String {
            switch(buttonName) {
            case  BoxNames.homeBox:
                if selectedScreen == .Home { break }
                homeBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.aboutBox:
                if selectedScreen == .About { break }
                aboutBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.privacyPolicyBox:
                privacyPolicyBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.helpBox:
                helpBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.rateBox:
                rateBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.feedbackBox:
                if selectedScreen == .Feedback { break }
                feedbackBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.settingsBox:
                if selectedScreen == .Settings { break }
                settingsBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.diagnosticsBox:
                if selectedScreen == .Diagnostics { break }
                diagnosticsBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.followUsBox:
                if selectedScreen == .FollowUs { break }
                followUsBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            case BoxNames.updateAppBox:
                if selectedScreen == .UpdateApp { break }
                updateAppBox.fillColor = NSColor.white
                NSCursor.arrow.set()
                break
            default:
                NSCursor.arrow.set()
            }
        }
    }
    
    @IBAction func privacyPolicyClick(_ sender: Any) {
        let url = URL(string: AppConfigurations.getPrivacyPolicyURL())!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func goHelp(_ sender: Any) {
        let url = URL(string: AppConfigurations.getHelpURL())!
        NSWorkspace.shared.open(url)
        
    }
    
    
    @IBAction func goRate(_ sender: Any) {
        let url = URL(string: AppConfigurations.getAppStoreURL())!
        NSWorkspace.shared.open(url)
        
    }
    
    @IBAction func diagnosticButtonPressed(_ sender: Any) {
        if selectedScreen == .Diagnostics { return }
        let loadDiagnosticsViewController = NSStoryboard.loadDiagnosticsViewController()
        self.window?.contentViewController = loadDiagnosticsViewController
    }
    @IBAction func goToFeedback(_ sender: Any) {
        if selectedScreen == .Feedback { return }
        let newViewController = NSStoryboard.loadFeedbackController()
        self.window?.contentViewController = newViewController
    }
    
    @IBAction func goHome(_ sender: Any) {
        if selectedScreen == .Home { return }
        let newViewController = NSStoryboard.loadHomeViewController()
        self.window?.contentViewController = newViewController
    }
    @IBAction func goAbout(_ sender: Any) {
        if selectedScreen == .About { return }
        let newViewController = NSStoryboard.loadAboutController()
        self.window?.contentViewController = newViewController
    }
    @IBAction func followUsButtonPressed(_ sender: Any) {
        if selectedScreen == .FollowUs { return }
        let followUsViewController = NSStoryboard.loadFollowUsViewController()
        self.window?.contentViewController = followUsViewController
    }
    
    @IBAction func goSettings(_ sender: Any) {
        if selectedScreen == .Settings { return }
        let loadSettingsViewController = NSStoryboard.loadSettingsViewController()
        self.window?.contentViewController = loadSettingsViewController
    }
    @IBAction func openTelegram(_ sender: Any) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(AppConfigurations.getTelegramID(), forType: .string)
        let alert = NSAlert()
        alert.messageText = LocalizedStringEnum.copiedText.localized
        alert.informativeText = LocalizedStringEnum.telegramIdCopiedAlert.localized
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
        
    }
    
    @IBAction func updateAppButtonPressed(_ sender: Any) {
        if selectedScreen == .UpdateApp { return }
        let loadAppUpdateViewController = NSStoryboard.loadAppUpdateViewController()
        self.window?.contentViewController = loadAppUpdateViewController
    }
}


