//
//  Utilities+UITextField.swift
//  nthLink
//
//  Created by Vaneet Modgill on 17/02/24.
//

import Cocoa


// MARK: - Properties
public extension NSTextField {

    
    @IBInspectable var localizeKey: String {
        get {
            return ""
        }
        set {
            if newValue != "" {
                self.stringValue = LocalizedStringEnum(rawValue: newValue)?.localized ?? ""
            }
        }
    }

}
