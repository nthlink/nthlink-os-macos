//
//  Extensions.swift
//  nthLink
//
//  Created by Vaneet Modgill on 5/28/23.
//

import Cocoa
import Foundation

extension NSTextField {
    public func customizeCaretColor () {
        let fieldEditor = self.window?.fieldEditor(true, for: self) as! NSTextView
        fieldEditor.insertionPointColor = NSColor.black
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 11 }
    var boldFont:NSFont { return NSFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:NSFont { return NSFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : NSColor.white,
            .backgroundColor : NSColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : NSColor.white,
            .backgroundColor : NSColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}


extension NSView {
    func setArea(name:String, obj: AnyObject) {
        let area = NSTrackingArea.init(rect: (obj as AnyObject).bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: ["btnName": name])
        (obj as AnyObject).addTrackingArea(area)
    }
}


extension NSViewController {
    func setArea(name:String, obj: AnyObject) {
        let area = NSTrackingArea.init(rect: (obj as AnyObject).bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: ["btnName": name])
        (obj as AnyObject).addTrackingArea(area)
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

public protocol EnumCollection : Hashable {}

extension EnumCollection {
    public static func allValues() -> [Self] {
        typealias S = Self
        let retVal = AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current = withUnsafePointer(to: &raw) {
                    $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee }
                }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
        return [S](retVal)
    }
}
