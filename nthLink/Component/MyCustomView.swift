//
//  MyRowView.swift
//  RoseVPN
//
//  Created by HJH on 2019/8/13.
//  Copyright © 2019 xing. All rights reserved.
//

import Cocoa

class MyCustomView: NSTableRowView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if isSelected == true {
            NSColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).set()
            __NSRectFill(dirtyRect)
        }
    }
}
