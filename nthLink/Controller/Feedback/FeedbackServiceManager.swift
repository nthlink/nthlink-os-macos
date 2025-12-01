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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.feedbackServiceManagerDidSuccessfulySubmitFeedback(feedbackServiceManager: self)
        }
    }
}
