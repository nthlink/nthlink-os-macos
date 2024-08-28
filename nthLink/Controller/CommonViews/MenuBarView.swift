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
}

@available(macOS 11.0, *)
class MenuBarView: NSView {
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var homeBox: NSBox!
    @IBOutlet weak var aboutBox: NSBox!
    @IBOutlet weak var privacyPolicyBox: NSBox!
    @IBOutlet weak var helpBox: NSBox!
    @IBOutlet weak var rateBox: NSBox!
    @IBOutlet weak var feedbackBox: NSBox!
    
    
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
        setArea(name: BoxNames.privacyPolicyBox, obj: privacyPolicyBox)
        setArea(name: BoxNames.helpBox, obj: helpBox)
        setArea(name: BoxNames.rateBox, obj: rateBox)
        self.setBackgroundColour()
    }
    
    private func setBackgroundColour() {
        homeBox.fillColor = NSColor.white
        feedbackBox.fillColor = NSColor.white
        aboutBox.fillColor = NSColor.white
        switch selectedScreen {
        case .Home:
            homeBox.fillColor = AppColors.appCreamColor
        case .Feedback:
            feedbackBox.fillColor = AppColors.appCreamColor
        case .About:
            aboutBox.fillColor = AppColors.appCreamColor
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
}


