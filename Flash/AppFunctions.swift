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
    if FileManager.default.isReadableFile(atPath: "/var/mobile") {
        if FileManager.default.isWritableFile(atPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist") {
            let UIKitPrefsFile = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist")
            let UIKitPrefsDict = plistToDict(path: UIKitPrefsFile)
            print(UIKitPrefsDict as Any)
            if UIKitPrefsDict!["UIAnimationDragCoefficient"] != nil {
                UIKitPrefsDict!["UIAnimationDragCoefficient"] = speed
            } else {
                UIKitPrefsDict?.setValue(speed, forKey: "UIAnimationDragCoefficient")
            }
            print(UIKitPrefsDict as Any)
            do {
                try writeDictToPlist(dict: UIKitPrefsDict!, path: UIKitPrefsFile)
            } catch {
                throw "Could not write plist, error: \(error.localizedDescription)"
            }
        } else {
            throw "UIKit Prefs is not writable!"
        }
    } else {
         throw "Not unsandboxed?!"
    }
}

func getSpeed() -> Double {
    let UIKitPrefsFile = URL(fileURLWithPath: "/var/mobile/Library/Preferences/com.apple.UIKit.plist")
    let UIKitPrefsDict = plistToDict(path: UIKitPrefsFile)
    // print(UIKitPrefsDict as Any)
    if UIKitPrefsDict!["UIAnimationDragCoefficient"] != nil {
        return UIKitPrefsDict!["UIAnimationDragCoefficient"] as! Double
    } else {
        return 1.0
    }
}
