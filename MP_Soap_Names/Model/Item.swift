//
//  Item.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
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
