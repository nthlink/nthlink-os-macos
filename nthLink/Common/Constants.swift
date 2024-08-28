//
//  Constants.swift
//  nthLink
//
//  Created by Vaneet Modgill on 13/04/24.
//

import Cocoa

var menuButton:NSStatusBarButton = NSStatusBarButton()

struct UserDefaultKeys {
    static let isPrivacyPolicyAccepted = "Accept_privacy"
}

struct AppColors {
    static let appBlueColor: NSColor = NSColor(red: 0.0, green: 97/255, blue: 255/255, alpha: 1)
    static let appCreamColor : NSColor = NSColor(red: 242/255, green: 234/255, blue: 214/255, alpha: 1)
    static let feedbackCellHoverColor = NSColor(red: 72/255, green: 62/255, blue: 163/255, alpha: 1)
}


struct AssetImagesString {
    static let menuConnected = "menu_connected"
    static let menuDisconnected = "menu_disconnected"
    static let logoWhite = "logo_white"
    static let logoBlue = "logo_blue"
    static let back = "back"
    static let forward = "forward"
}



struct CommonStings {
    static let appName = "nthLink"
  
}

struct Constants {
    static var appBunleId = "com.nthlink.macos.client"
}


struct BoxNames {
    static let homeBox = "homeBox"
    static let feedbackBox = "feedbackBox"
    static let aboutBox = "aboutBox"
    static let privacyPolicyBox = "privacyPolicyBox"
    static let helpBox = "helpBox"
    static let rateBox = "rateBox"
    static let btGeneral = "btGeneral"
    static let btCantConnect = "btCantConnect"
    static let btSpeedLow = "btSpeedLow"
    static let btSuggestion = "btSuggestion"
    static let btOther = "btOther"

}
