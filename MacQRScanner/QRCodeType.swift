//
//  QRCodeType.swift
//  MacQRScanner
//
//  Created by Shuaiwei Yu on 14.02.25.
//

import Foundation

enum QRCodeType {
    case url(URL)
    case email(String, subject: String?, body: String?)
    case wifi(ssid: String, password: String)
    case text(String)
}
