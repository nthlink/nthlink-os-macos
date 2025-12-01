//
//  NSStoryBoard+Loader.swift
//  nthLink
//
//  Created by Vaneet Modgill on 13/04/24.
//

import Foundation

import Cocoa
fileprivate enum Storyboard : String {
    case main = "Main"
}

fileprivate extension NSStoryboard {
    static func loadFromMain(_ identifier: String) -> NSViewController {
        return load(from: .main, identifier: identifier)
    }

    static func load(from storyboard: Storyboard, identifier: String) -> NSViewController {
        let uiStoryboard = NSStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateController(withIdentifier: identifier) as! NSViewController
    }
}


// MARK:  MAIN/FEEDBACK/SEARCH/TIMELINE
extension NSStoryboard {
    
    static func loadHomeViewController()->HomeController {
        return loadFromMain(HomeController.className) as! HomeController
    }

    static func loadPrivacyController() -> PrivacyController {
        return loadFromMain(PrivacyController.className) as! PrivacyController
    }
    
    static func loadFeedbackController() -> FeedbackController {
        return loadFromMain(FeedbackController.className) as! FeedbackController
    }
    
    static func loadAboutController() -> AboutController {
        return loadFromMain(AboutController.className) as! AboutController
    }
    
    static func loadSettingsViewController() -> SettingsViewController {
        return loadFromMain(SettingsViewController.className) as! SettingsViewController
    }
    static func loadFollowUsViewController() -> FollowUsViewController {
        return loadFromMain(FollowUsViewController.className) as! FollowUsViewController
    }
    
    static func loadDiagnosticsViewController() -> DiagnosticsViewController {
        return loadFromMain(DiagnosticsViewController.className) as! DiagnosticsViewController
    }
    
    static func loadAppUpdateViewController() -> AppUpdateViewController {
        return loadFromMain(AppUpdateViewController.className) as! AppUpdateViewController
    }
    
}






