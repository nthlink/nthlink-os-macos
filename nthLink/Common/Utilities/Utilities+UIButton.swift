//
//  Utilities+UIButton.swift
//  nthLink
//
//  Created by Vaneet Modgill on 17/02/24.
//

import Cocoa


//MARK:- Button Theme
extension NSButton{
   
    @IBInspectable public var localizeKey: String {
        get {
            return ""
        }
        set {
            if newValue != "" {
                self.title = LocalizedStringEnum(rawValue: newValue)?.localized ?? ""
            }
        }
    }

    
}

