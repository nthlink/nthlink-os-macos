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
    
    @available(macOS 11.0, *)
    static func loadHomeViewController()->HomeController {
        return loadFromMain(HomeController.className) as! HomeController
    }

    @available(macOS 11.0, *)
    static func loadPrivacyController() -> PrivacyController {
        return loadFromMain(PrivacyController.className) as! PrivacyController
    }
    
    @available(macOS 11.0, *)
    static func loadFeedbackController() -> FeedbackController {
        return loadFromMain(FeedbackController.className) as! FeedbackController
    }
    
    @available(macOS 11.0, *)
    static func loadAboutController() -> AboutController {
        return loadFromMain(AboutController.className) as! AboutController
    }
}






