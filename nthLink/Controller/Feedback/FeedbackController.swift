//
//  FeedbackController.swift
//  nthLink
//
//  Created by Vaneet Modgill on 5/24/23.
//

import Cocoa
import FlatButton

@available(macOS 11.0, *)
class FeedbackController: AppBaseViewController {
    @IBOutlet weak var tfEmail: NSTextField!
    @IBOutlet weak var lbDescription: NSTextView!
    @IBOutlet weak var lbOther: NSTextField!
    @IBOutlet weak var btOther: FlatButton!
    @IBOutlet weak var btGeneral: FlatButton!
    @IBOutlet weak var lbGeneral: NSTextField!
    @IBOutlet weak var btCantConnect: FlatButton!
    @IBOutlet weak var lbCantConnect: NSTextField!
    @IBOutlet weak var btSpeedLow: FlatButton!
    @IBOutlet weak var lbSpeedLow: NSTextField!
    @IBOutlet weak var lbSuggestion: NSTextField!
    @IBOutlet weak var btSuggestion: FlatButton!
    @IBOutlet weak var lbErrorType: NSTextField!
    @IBOutlet weak var dropDownBox: NSBox!
    @IBOutlet weak var menuView: NSView!
    private var serviceManager = FeedbackServiceManager()
    private var isDropDown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
    }
    
    private func setupInitialData(){
        preferredContentSize = NSSize(width: 420, height: 550)
        self.serviceManager.delegate = self
        lbDescription.backgroundColor = NSColor.white
        lbDescription.layer?.backgroundColor = NSColor.white.cgColor
        setArea(name: BoxNames.btGeneral, obj: btGeneral)
        setArea(name: BoxNames.btCantConnect, obj: btCantConnect)
        setArea(name: BoxNames.btSpeedLow, obj: btSpeedLow)
        setArea(name: BoxNames.btSuggestion, obj: btSuggestion)
        setArea(name: BoxNames.btOther, obj: btOther)
        addShadow(view: dropDownBox)
        setupSideMenuBar()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        tfEmail.customizeCaretColor()
    }
    


    @available(macOS 12, *)
    @IBAction func sendFeedback(_ sender: Any) {
        if serviceManager.selectedFeedbackErrorType == "" {
            showCommonAlert(message: LocalizedStringEnum.feedbackErrorSelectType.localized)
            return
        }
        if lbDescription.string == "" {
            showCommonAlert(message: LocalizedStringEnum.feedbackErrorAddDescription.localized)
            return
        }
        self.serviceManager.submitFeedback(emailID: tfEmail.stringValue, description: lbDescription.string)
    }
    
    @IBAction func selectErrorType(_ sender: Any) {
        dropDownBox.isHidden = isDropDown
        isDropDown = !isDropDown
    }
    
    func showCategory(type:String) {
        isDropDown = false
        dropDownBox.isHidden = true
        serviceManager.selectedFeedbackErrorType = type
        lbErrorType.stringValue = type
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 100, height: 550))
        menuBarView.selectedScreen = .Feedback
        menuBarView.reloadView()
        self.menuView.addSubview(menuBarView)
        menuBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBarView.centerXAnchor.constraint(equalTo: self.menuView.centerXAnchor),
            menuBarView.centerYAnchor.constraint(equalTo: self.menuView.centerYAnchor),
            menuBarView.widthAnchor.constraint(equalToConstant: 100),
            menuBarView.heightAnchor.constraint(equalToConstant: 550)
        ])
    }
    
    @IBAction func clickGeneral(_ sender: Any) {
        showCategory(type: LocalizedStringEnum.issue_categories_1.localized)
    }
    
    @IBAction func clickCantConnect(_ sender: Any) {
        showCategory(type: LocalizedStringEnum.issue_categories_2.localized)
    }
    
    @IBAction func clickSpeedLow(_ sender: Any) {
        showCategory(type: LocalizedStringEnum.issue_categories_3.localized)
    }
    
    @IBAction func clickSugestion(_ sender: Any) {
        showCategory(type: LocalizedStringEnum.issue_categories_4.localized)
    }
    
    @IBAction func clickOther(_ sender: Any) {
        showCategory(type: LocalizedStringEnum.issue_categories_5.localized)
    }
    
    override func mouseEntered(with event: NSEvent) {
        if let buttonName = event.trackingArea?.userInfo?.values.first as? String {
            switch(buttonName) {
            case BoxNames.btGeneral:
                lbGeneral.textColor = AppColors.feedbackCellHoverColor
                NSCursor.arrow.set()
                break
            case BoxNames.btCantConnect:
                lbCantConnect.textColor = AppColors.feedbackCellHoverColor
                NSCursor.arrow.set()
                break
            case BoxNames.btSpeedLow:
                lbSpeedLow.textColor = AppColors.feedbackCellHoverColor
                NSCursor.arrow.set()
                break
            case BoxNames.btSuggestion:
                lbSuggestion.textColor = AppColors.feedbackCellHoverColor
                NSCursor.arrow.set()
                break
            case BoxNames.btOther:
                lbOther.textColor = AppColors.feedbackCellHoverColor
                NSCursor.arrow.set()
                break
            default:
                NSCursor.pointingHand.set()
            }
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        if let buttonName = event.trackingArea?.userInfo?.values.first as? String {
            switch(buttonName) {
            case BoxNames.btGeneral:
                lbGeneral.textColor = NSColor.black
                break
            case  BoxNames.btCantConnect:
                lbCantConnect.textColor = NSColor.black
                break
            case BoxNames.btSpeedLow:
                lbSpeedLow.textColor = NSColor.black
                break
            case BoxNames.btSuggestion:
                lbSuggestion.textColor = NSColor.black
                break
            case BoxNames.btOther:
                lbOther.textColor = NSColor.black
                break
            default:
                NSCursor.arrow.set()
            }
        }
    }
}

@available(macOS 11.0, *)
extension FeedbackController:FeedbackServiceManagerDelegate{
    func feedbackServiceManagerDidSuccessfulySubmitFeedback(feedbackServiceManager:FeedbackServiceManager) {
        self.showCommonAlert(message: LocalizedStringEnum.feedback_submit_success_message.localized)
    }
    
    func feedbackServiceManagerDidFailToSendFeedback(feedbackServiceManager:FeedbackServiceManager) {
        self.showCommonAlert(message: LocalizedStringEnum.somethingWentWrong.localized)
    }
}
