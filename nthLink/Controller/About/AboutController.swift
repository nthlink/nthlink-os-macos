//
//  AboutController.swift
//  nthLink
//
//  Created by RuiHua on 5/22/23.
//

import Cocoa

class AboutController: AppBaseViewController {
    @IBOutlet private weak var lbVersion: NSTextField!
    @IBOutlet private weak var lbAbout: NSTextField!
    @IBOutlet private weak var menuView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialData()
    }

    override func viewDidAppear() {
       super.viewDidAppear()
    }
    
    
    private func setupInitialData(){
        preferredContentSize = NSSize(width: 630, height: 825)
        self.view.wantsLayer = true
        lbVersion.stringValue = "\(LocalizedStringEnum.about_version.localized) \(Utilities.appVersionNumber ?? 0)"
        var attrString = NSMutableAttributedString(attributedString: LocalizedStringEnum.about_text.localized.html2AttributedString ?? NSAttributedString())
        attrString.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: 15), range: NSMakeRange(0, attrString.length))
        lbAbout.attributedStringValue = attrString
//        lbAbout.attributedStringValue = LocalizedStringEnum.about_text.localized.html2AttributedString ?? NSAttributedString()
        lbAbout.font =  NSFont.systemFont(ofSize: 15)
        setupSideMenuBar()
    }
    
    private func setupSideMenuBar(){
        let menuBarView = MenuBarView(frame: NSRect(x: 0, y: 0, width: 150, height: 825))
        menuBarView.selectedScreen = .About
        menuBarView.reloadView()
        self.menuView.addSubview(menuBarView)
        menuBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBarView.centerXAnchor.constraint(equalTo: self.menuView.centerXAnchor),
            menuBarView.centerYAnchor.constraint(equalTo: self.menuView.centerYAnchor),
            menuBarView.widthAnchor.constraint(equalToConstant: 150),
            menuBarView.heightAnchor.constraint(equalToConstant: 825)
        ])
    }

//    private func convertHTMLStringToAttributedString(_ htmlString: String) -> NSAttributedString? {
//           do {
//               // Define attributes for the attributed string
//               let attributes: [NSAttributedString.Key: Any] = [
//                   .font: NSFont.systemFont(ofSize: 16),
//                   .foregroundColor: NSColor.black
//               ]
//
//               // Convert HTML string to attributed string
//               guard let data = htmlString.data(using: .utf8) else {
//                   return nil
//               }
//
//               let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//                   .documentType: NSAttributedString.DocumentType.html,
//                   .characterEncoding: String.Encoding.utf8.rawValue
//               ]
//
//               let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
//               
//               // Apply custom attributes
//               let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
//               mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.length))
//
//               return mutableAttributedString
//           } catch {
//               print("Error converting HTML string to attributed string: \(error)")
//               return nil
//           }
//       }
}
