//
//  AppFunctions.swift
//  Flash
//
//  Created by Hariz Shirazi on 2023-04-12.
//

import Foundation
// ooo spoopy
import AbsoluteSolver

// thanks f1sh 🥺

func writeDictToPlist(dict: NSMutableDictionary, path: URL) throws {
    //dict.removeObjects(forKeys: CCMappings.removalPlistValues)
    var newData: Data? = nil
    do {
        newData = try PropertyListSerialization.data(fromPropertyList: dict as! [String: Any], format: .binary, options: 0)
    } catch {
        throw "Could not serialize plist! \(error.localizedDescription)"
    }
    if newData != nil {
        do {
            try AbsoluteSolver.replace(at: path, with: newData! as NSData)
        } catch {
            throw error.localizedDescription
        }
    } else {
        throw "Did not serialize plist?!"
    }
}

func plistToDict(path: URL) -> NSMutableDictionary? {
    return NSMutableDictionary(contentsOf: path)
}

// <3 chatgpt
func getKeysFromDict(from dictionary: [String: Any], prefix: String = "") -> [String] {
    var keys: [String] = []
    for (key, value) in dictionary {
        let newPrefix = prefix.isEmpty ? key : "\(prefix).\(key)"
        if let subDict = value as? [String: Any] {
            keys += getKeysFromDict(from: subDict, prefix: newPrefix)
        } else {
            keys.append(newPrefix)
        }
    }
    return keys
}

// gamering time

func changeSpeed(_ speed: Double) throws {
    // set stuff
    let fm = FileManager.default
    if fm.isReadableFile(atPath: "/var/mobile") {
        print("Unsandboxed")
        let attributes = [FileAttributeKey.posixPermissions: 0o666]
        
        do {
            try fm.setAttributes(attributes, ofItemAtPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist")
            print("Set attributes \(attributes) on /var/mobile/Library/Preferences/com.apple.UIKit.plist")
        } catch {
            print("Warning: could not set attributes of plist")
        }
        if fm.isReadableFile(atPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist") {
            if fm.isWritableFile(atPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist") {
                print("Can write to plist")
                let UIKitPrefsFile = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist")
                if let UIKitPrefsDict = plistToDict(path: UIKitPrefsFile) {
                    print(UIKitPrefsDict as Any)
                    if UIKitPrefsDict["UIAnimationDragCoefficient"] != nil {
                        UIKitPrefsDict["UIAnimationDragCoefficient"] = speed
                    } else {
                        UIKitPrefsDict.setValue(speed, forKey: "UIAnimationDragCoefficient")
                    }
                    print(UIKitPrefsDict as Any)
                    do {
                        try writeDictToPlist(dict: UIKitPrefsDict, path: UIKitPrefsFile)
                    } catch {
                        throw "Could not write plist, error: \(error.localizedDescription)"
                        
                    }
                    print(plistToDict(path: UIKitPrefsFile)!["UIAnimationDragCoefficient"] as Any)
                    if !((plistToDict(path: UIKitPrefsFile)!["UIAnimationDragCoefficient"]) as! Double == speed) {
                        throw "File wasn't overwritten!"
                    }
                    let plistcontent = String(decoding: try! AbsoluteSolver.readFile(path: "/var/mobile/Library/Preferences/com.apple.UIKit.plist"), as: UTF8.self)
                    print(plistcontent)
                } else {
                    throw "Unable to serialize plist!"
                }
            } else {
                throw "UIKit Prefs is not writable!"
            }
        } else {
            throw "UIKit Prefs is not readable! Wtf?!"
        }
    } else {
         throw "Not unsandboxed?!"
    }
}

func getSpeed() -> Double {
    let UIKitPrefsFile = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist")
        if let UIKitPrefsDict = plistToDict(path: UIKitPrefsFile) {
        // print(UIKitPrefsDict as Any)
        if UIKitPrefsDict["UIAnimationDragCoefficient"] != nil {
        return UIKitPrefsDict["UIAnimationDragCoefficient"] as! Double
    } else {
        return 1.0
    }
    } else {
        print("File not readable?!")
        return 1.0
    }
}
