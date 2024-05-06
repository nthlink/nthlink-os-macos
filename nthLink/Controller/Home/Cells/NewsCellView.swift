//
//  NewsCellView.swift
//  nthLink
//
//  Created by Vaneet Modgill on 6/2/23.
//

import Cocoa
import WebKit

class NewsCellView: NSTableCellView {
    @IBOutlet weak var viewNews: NSBox!
    @IBOutlet weak var viewNotificaiton: NSBox!
    @IBOutlet weak var viewOdd: NSBox!
    @IBOutlet weak var lbNotification: NSTextField!
    @IBOutlet weak var lbTitle: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func set(news:CommonNewsData,index:Int) {
        if news.type == 0 {
            viewNotificaiton.isHidden = false
            viewNews.isHidden = true
        } else {
            viewNotificaiton.isHidden = true
            viewNews.isHidden = false
            if (index % 2 != 0) {
                viewOdd.isHidden = false
            } else {
                viewOdd.isHidden = true
            }
        }
        
        lbNotification.stringValue = news.data.title ?? ""
        lbTitle.stringValue = news.data.title ?? ""
    }
 
}
