//
//  Item.swift
//  MacQRScanner
//
//  Created by Shuaiwei Yu on 27.01.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
