//
//  habit.swift
//  Habittrackerxcode
//
//  Created by Pinar Bildirici on 2026-04-30.
//

import Foundation
import SwiftData

@Model
final class habit {
    var name: String
    var notes: String
    var timestamp: Date
    
    init(name: String = "", notes: String = "", timestamp: Date = .now) {
        self.name = name
        self.notes = notes
        self.timestamp = timestamp
    }
}
