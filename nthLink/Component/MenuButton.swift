//
//  MenuButton.swift
//  TitanMacos
//
//  Created by 안영재 on 2019/12/30.
//  Copyright © 2019 안영재. All rights reserved.
//
//import Cocoa
//import Foundation
//
//class MenuButton: NSButton {
//    
//    var beforeImage: NSImage!
//    var isClicked: Bool = false
//    
//    
//    //override func mouseUp(with event: NSEvent) {
//    //    print("mouseUp")
//    //    isClicked = true
//    //}
//    //override func mouseDown(with event: NSEvent) {
//    //    print("mouseDown")
//    //}
//    override func mouseEntered(with event: NSEvent) {
//        beforeImage = self.image
//        
//        if self.tag == 1{
//            self.image = NSImage(named: "home_white")
//        }
//        else if self.tag == 2{
//            self.image = NSImage(named: "feedback_white")
//        }
//        else if self.tag == 3{
//            self.image = NSImage(named: "about_white")
//        }
//        else if self.tag == 4{
//            self.image = NSImage(named: "cd_white")
//        }
//        else if  self.tag == 5{
//            self.image = NSImage(named: "ext_white")
//        }
//        else if  self.tag == 6{
//            self.image = NSImage(named: "update_white")
//        }
//    }
//    override func mouseExited(with event: NSEvent) {
//        if (isClicked == false) {
//            self.image = beforeImage
//        }
//        else {
//            isClicked = false
//        }
//        
////        if isClicked == false{
////            switch (self.tag){
////            case 1:
////                self.image = NSImage(named: "ntw")
////                break
////            case 2:
////                self.image = NSImage(named: "usr")
////                break
////            case 3:
////                self.image = NSImage(named: "cng")
////                break
////            case 4:
////                self.image = NSImage(named: "cd")
////                break
////            case 5:
////                self.image = NSImage(named: "ext")
////                break
////            default:
////                break
////            }
////        }
////        else{
////            isClicked = false
////        }
//        
////        if self.tag == 1{
////            self.image = NSImage(named: "network")
////
////        }
////        else if self.tag == 2{
////            self.image = NSImage(named: "user")
////
////        }
////        else if self.tag == 3{
////            self.image = NSImage(named: "change")
////        }
////        else if self.tag == 4{
////            self.image = NSImage(named: "card")
////        }
////        else if  self.tag == 5{
////            self.image = NSImage(named: "exit")
////        }
//        
//    }
//
//    
//    override func updateTrackingAreas() {
//        for trackingArea in self.trackingAreas {
//            self.removeTrackingArea(trackingArea)
//        }
//        
//        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
//        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
//        self.addTrackingArea(trackingArea)
//        
//    }
//}
