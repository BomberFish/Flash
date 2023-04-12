//
//  FlashApp.swift
//  Flash
//
//  Created by Hariz Shirazi on 2023-04-12.
//

import SwiftUI
import MacDirtyCow

let appVersion = ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown") + " (" + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown") + ")")
var escaped = false

@main
struct FlashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
#if targetEnvironment(simulator)
#else
                    if #available(iOS 16.2, *) {
                        UIApplication.shared.alert(title: "Not Supported", body: "This version of iOS is not supported.")
                    } else {
                        do {
                            if UserDefaults.standard.bool(forKey: "ForceMDC") == true {
                                throw "Forcing MDC"
                            }
                            // TrollStore method
                            try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: "/var/mobile/Library/Caches"), includingPropertiesForKeys: nil)
                            escaped = true
                        } catch {
                            // MDC method
                            // grant r/w access
                            if #available(iOS 15, *) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    do {
                                        try MacDirtyCow.unsandbox()
                                        escaped = true
                                    } catch {
                                        escaped = false
                                        UIApplication.shared.alert(body: "Unsandboxing Error: \(error.localizedDescription)\nPlease close the app and retry. If the problem persists, reboot your device.", withButton: false)
                                    }
                                }
                            } else {
                                UIApplication.shared.alert(title: "MDC Not Supported", body: "Please install via TrollStore")
                            }
                        }
                    }
#endif
                }
        }
    }
}
