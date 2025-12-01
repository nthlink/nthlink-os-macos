//
//  Function.swift
//  nthLink
//
//  Created by RuiHua on 5/26/23.
//

import Cocoa
import IOKit
import Foundation

func dialogOKCancel(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    return alert.runModal() == .alertFirstButtonReturn
}

func dialogOK(text: String)  -> Bool {
    let alert = NSAlert()
    alert.messageText = ""
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    return alert.runModal() == .alertFirstButtonReturn
}

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

func getSystemUUID() -> String? {
    let dev = IOServiceMatching("IOPlatformExpertDevice")
    let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
    let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
    IOObjectRelease(platformExpert)
    let ser: CFTypeRef = serialNumberAsCFString!.takeUnretainedValue()
    if let result = ser as? String {
        return result
    }
    return nil
}

public func getMacModel() -> String? {
    let service = IOServiceGetMatchingService(kIOMasterPortDefault,
                                              IOServiceMatching("IOPlatformExpertDevice"))
    var modelIdentifier: String?

    if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
        if let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(using: .utf8) {
            modelIdentifier = String(cString: modelIdentifierCString)
        }
    }

    IOObjectRelease(service)
    return modelIdentifier
}

func getUniqueIDForMac()->String{
    let keyForUserDefault = "uniqueIDForMac"
    if let uniqueID = UserDefaults.standard.string(forKey: keyForUserDefault) {
        return uniqueID
    }
    print("No value found for key 'uniqueIDForMac'")
    let uuidString = UUID().uuidString
    UserDefaults.standard.set(uuidString, forKey: keyForUserDefault)
    return uuidString
}


func addShadow(view:NSView) {
    view.wantsLayer = true
    view.shadow = NSShadow()
    view.layer?.shadowOpacity = 0.5
    view.layer?.shadowColor = NSColor.black.cgColor
    view.layer?.shadowOffset = NSMakeSize(0, 0)
    view.layer?.shadowRadius = 10.0
}
