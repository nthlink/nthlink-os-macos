//
//  LocalizedStringEnum.swift
//  nthLink
//
//  Created by Vaneet Modgill on 17/02/24.
//

import Foundation


enum LocalizedStringEnum:String {
    
    
    case openNthlinkText
    case quitNthlinkText

    //Menu View Controller
    case Home
    case Feedback
    case About
    case Help
    case RateApp
    case PrivacyPolicy
    case settingsScreen
    case telegramIDText
    case copiedText
    case telegramIdCopiedAlert
    case followUsText
    case diagnosticPageTitle
    case UpdateAppMenu




    //About Controller
    case about_text
    case about_version
//
    //Feedback View Controller
    case issue_categories_1
    case issue_categories_2
    case issue_categories_3
    case issue_categories_4
    case issue_categories_5
    case feedback_submit
    case feedback_submit_success_message
    case feedbackErrorSelectType
    case feedbackErrorAddDescription
    case IssueCategory
    case feedbackEmailIDLabel
    case Description
    case feedbackSubtext

    // General
    case somethingWentWrong
    case OK
    case Cancel
    case loading
    
    //HomeViewController
    case Connecting
    case Disconnect
    case Connect
    case Disconnecting
    case homeReadLatestNews

    //privacy policy
    case privacyPolicyAgreeButton
    case privacyPolicyLearnMoreButton
    
    //MenuBar
    case menuBarHideText
    case menuBarHideOthersText
    case menuBarShowAllext
    case menuBarQuitText
    
    //StatusBar
    case statusBarPrivacyAlert
    case statusBarConnectedText
    case statusBarNotConnectedText
    case statusBarOpenAppText
    case statusBarNewsText
    case statusBarReloadText
    
    //Settings
    case settingsShowMenuBarText
    
    //FollowUs Page
    case visitButtonText
    
    //Diagnostics
    case diagnosticsStartButton
    case diagnosticsDescription
    case diagnosticsSuceessMessage
    case diagnosticsInternetError
    case diagnosticsStartDisconnectWarning
    
    case updateScreenLabel
    case updateScreenSubtext
    case updateScreenUpdateNowButtonText
    
    var localized:String{
        return self.rawValue.localized
    }
    
}


extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String
    {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: "**\(self)**", comment: "")
    }
}
