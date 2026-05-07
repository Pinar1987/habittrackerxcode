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
        let uniqueDates = Set(completedDates.map { calendar.startOfDay(for: $0) })
        let sortedDates = uniqueDates.sorted(by: >)
        
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
          
        
        if !uniqueDates.contains(checkDate) {
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        for date in sortedDates {
            if date == checkDate {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if date < checkDate {
                break
            }
        }
        return streak
    }
    
   
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDates.contains { calendar.isDateInToday($0) }
    }
}
