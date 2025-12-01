//
//  Utilities.swift
//  nthLink
//
//  Created by Vaneet Modgill on 17/02/24.
//

import Cocoa

class Utilities:NSObject{
    
    static var appVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
    
    func getMacModel() -> String? {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.model", &machine, &size, nil, 0)
        return String(cString: machine)
    }

}
