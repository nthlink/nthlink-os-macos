//
//  AppConfiguration.swift
//  nthLink
//
//  Created by Vaneet Modgill on 13/04/24.
//

import Foundation



class AppConfigurations {
    
 
    static func getHomeURL() -> String{
      return  "https://www.nthlink.com/"
    }


    static func getHelpURL() -> String{
        return "https://s3.us-west-1.amazonaws.com/dwo-jar-kmf-883/help.html"
    }
    
    static func getAppStoreURL() -> String{
        let appID = 1536318872
        return "itms-apps://itunes.apple.com/app/id\(appID)?mt=8&action=write-review"
    }

    static func getPrivacyPolicyURL() -> String{
        return "https://www.nthlink.com/policies/"
    }
  
    
}

