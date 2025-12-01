//
//  StatusBarNewsCellView.swift
//  nthLink
//
//  Created by Vaneet on 6/2/23.
//

import Cocoa
import WebKit

class StatusBarNewsCellView: NSTableCellView,WKNavigationDelegate {
    @IBOutlet weak var viewNews: NSBox!
    @IBOutlet weak var viewHeadline: NSBox!
    @IBOutlet weak var viewOdd: NSBox!
    @IBOutlet weak var webview: ForwardingWKWebView!
    @IBOutlet weak var lbUrl: NSTextField!
    @IBOutlet weak var lbTitle: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webview.navigationDelegate = self
    }
    
    func set(news:CommonNewsData,index:Int) {

        if news.type == 0 {
            viewHeadline.isHidden = true
            viewNews.isHidden = true
            print("Scroll View: Notification")
        } else if news.type == 1 {
            viewHeadline.isHidden = false
            viewNews.isHidden = true
            let link = URL(string: news.data.url ?? "")
            lbUrl.stringValue = news.data.url ?? ""
            webview.load(URLRequest(url: link!))
        } else {
            viewHeadline.isHidden = true
            viewNews.isHidden = false
            if (index % 2 != 0) {
                viewOdd.isHidden = false
            } else {
                viewOdd.isHidden = true
            }
        }
        
        lbTitle.stringValue = news.data.title ?? ""
    }
    @IBAction func goToWeb(_ sender: Any) {
        let url = URL(string: lbUrl.stringValue)!
        NSWorkspace.shared.open(url)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           // Adjust zoom scale to 80% after the web page is loaded
        let javascript = "document.body.style.zoom = '50%';"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    
}

