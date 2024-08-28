//
//  Function.swift
//  nthLink
//
//  Created by Vaneet Modgill on 5/26/23.
//

import Cocoa
import IOKit
import Foundation


func showDock(state: Bool) -> Bool {
    // Get transform state.
    var transformState: ProcessApplicationTransformState
    if state {
        transformState = ProcessApplicationTransformState(kProcessTransformToForegroundApplication)
    } else {
        transformState = ProcessApplicationTransformState(kProcessTransformToUIElementApplication)
    }

    // Show / hide dock icon.
    var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
    let transformStatus: OSStatus = TransformProcessType(&psn, transformState)

    return transformStatus == 0
}


func addShadow(view:NSView) {
    view.wantsLayer = true
    view.shadow = NSShadow()
    view.layer?.shadowOpacity = 0.5
    view.layer?.shadowColor = NSColor.black.cgColor
    view.layer?.shadowOffset = NSMakeSize(0, 0)
    view.layer?.shadowRadius = 10.0
}
