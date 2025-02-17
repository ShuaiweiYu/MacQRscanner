//
//  MacQRScannerApp.swift
//  MacQRScanner
//
//  Created by Shuaiwei Yu on 27.01.25.
//

import SwiftUI

@main
struct QRScannerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
