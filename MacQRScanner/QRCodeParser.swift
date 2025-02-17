//
//  QRCodeParser.swift
//  MacQRScanner
//
//  Created by Shuaiwei Yu on 15.02.25.
//

import Vision

class QRCodeParser {
    
    /**
     Categorizes QR code content into specific types
     
     Supports parsing for:
     - Email (MATMSG/mailto formats)
     - URLs (http/https)
     - WiFi credentials
     - Plain text
     
     - Parameters:
        - content: Raw QR code content string
     
     - Returns: QRCodeType enum with associated values
     */
    public func parseQRCodeType(_ content: String) -> QRCodeType {
        let lowercasedContent = content.lowercased()

        if lowercasedContent.hasPrefix("matmsg:") {
            let emailInfo = parseMATMSGEmail(content)
            return .email(emailInfo.to, subject: emailInfo.subject, body: emailInfo.body)
        }

        if lowercasedContent.hasPrefix("mailto:") {
            let email = content.replacingOccurrences(of: "mailto:", with: "")
            return .email(email, subject: nil, body: nil)
        }

        if let url = URL(string: content), url.scheme == "http" || url.scheme == "https" {
            return .url(url)
        }

        if lowercasedContent.hasPrefix("wifi:") {
            let wifiInfo = parseWiFiInfo(content)
            return .wifi(ssid: wifiInfo.ssid, password: wifiInfo.password)
        }

        return .text(content)
    }

    /**
     Parses MATMSG formatted email content
     
     Expected format: "MATMSG:TO:email;SUB:subject;BODY:body;"
     
     - Parameters:
        - emailString: The raw MATMSG string to parse
     
     - Returns: Tuple containing:
        - to: Recipient email (required)
        - subject: Optional email subject
        - body: Optional email body
     */
    private func parseMATMSGEmail(_ emailString: String) -> (to: String, subject: String?, body: String?) {
        let content = emailString.replacingOccurrences(of: "MATMSG:", with: "")
        var to: String = ""
        var subject: String?
        var body: String?

        let components = content.split(separator: ";").map { $0.split(separator: ":").map { String($0) } }
        
        for pair in components {
            if pair.count == 2 {
                let key = pair[0].uppercased()
                let value = pair[1]
                if key == "TO" { to = value }
                if key == "SUB" { subject = value }
                if key == "BODY" { body = value }
            }
        }

        return (to, subject, body)
    }
    
    /**
     Extracts WiFi credentials from WIFI: formatted string
     
     Expected format: "WIFI:S:ssid;P:password;"
     
     - Parameters:
        - wifiString: The raw WIFI: string to parse
     
     - Returns: Tuple containing:
        - ssid: Network name (defaults to "Unknown")
        - password: Network password (empty string if missing)
     */
    private func parseWiFiInfo(_ wifiString: String) -> (ssid: String, password: String) {
        let components = wifiString.replacingOccurrences(of: "WIFI:", with: "")
            .split(separator: ";")
            .map { $0.split(separator: ":").map { String($0) } }

        var ssid = "Unknown"
        var password = ""

        for pair in components {
            if pair.count == 2 {
                let key = pair[0].uppercased()
                let value = pair[1]
                if key == "S" { ssid = value }
                if key == "P" { password = value }
            }
        }
        return (ssid, password)
    }
}
