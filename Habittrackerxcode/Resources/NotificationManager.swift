//
//  NotificationManager.swift
//  Habittrackerxcode
//
//  Created by Pinar Bildirici on 2026-05-04.
//

import Foundation
import UserNotifications

    class NotificationManager {
    static let instance = NotificationManager()
    
        // Notification //
        func requestAuthorization() {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
                if success {
                    print("Notification Approved ✅")
                } else if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                }
            }
        }
        
        
        func scheduleNotification(habitName: String) {
            let content = UNMutableNotificationContent()
            content.title = "Habit time! 🔥"
            content.body = "\(habitName) did you get a step today?"
            content.sound = .default
            
            // remember me at same time every day //
            var dateComponents = DateComponents()
            dateComponents.hour = 20
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: habitName, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
