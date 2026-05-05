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
    var completedDates: [Date] = []
    var hexColor: String = "#3498db"
    
             
       
            
    init(name: String = "", notes: String = "", timestamp: Date = .now, hexColor: String = "#3498db") {
                self.name = name
                self.notes = notes
                self.timestamp = timestamp
                self.completedDates = []
                self.hexColor = hexColor
            }
            
            // Streak//
            var currentStreak: Int {
                guard !completedDates.isEmpty else { return 0 }
                
                let calendar = Calendar.current
                // Tarihleri gün başlangıcına normalize et ve benzersiz yap (Set kullanarak)
                let uniqueDates = Set(completedDates.map { calendar.startOfDay(for: $0) })
                let sortedDates = uniqueDates.sorted(by: >) // En yeni tarihten eskiye
                
                var streak = 0
                var checkDate = calendar.startOfDay(for: Date()) // Bugünden geriye kontrol başlasın
                
                for date in sortedDates {
                    if date == checkDate {
                        streak += 1
                        checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
                    } else if date < checkDate {
                        break // Seri bozuldu
                    }
                }
                return streak
            }
            
            
            var isCompletedToday: Bool {
                let calendar = Calendar.current
                return completedDates.contains { calendar.isDateInToday($0) }
            
        
    }
}
