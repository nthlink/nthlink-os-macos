//
//  FeedbackServiceManager.swift
//  nthLink
//
//  Created by Vaneet Modgill on 14/04/24.
//

import Cocoa

protocol FeedbackServiceManagerDelegate:AnyObject {
    func feedbackServiceManagerDidSuccessfulySubmitFeedback(feedbackServiceManager:FeedbackServiceManager)
    func feedbackServiceManagerDidFailToSendFeedback(feedbackServiceManager:FeedbackServiceManager)
}


class FeedbackServiceManager {
    var selectedFeedbackErrorType = LocalizedStringEnum.issue_categories_1.localized
    weak var delegate:FeedbackServiceManagerDelegate?
    
    @available(macOS 12, *)
    func submitFeedback(emailID:String?, description:String?){
        let result = 200 // Hit API and handle the success
        if result == 200 {
            self.delegate?.feedbackServiceManagerDidSuccessfulySubmitFeedback(feedbackServiceManager: self)
            return
        }
        self.delegate?.feedbackServiceManagerDidFailToSendFeedback(feedbackServiceManager: self)
    }
}
