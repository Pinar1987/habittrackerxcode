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
        
        
        func scheduleNotification(habitName: String, at date: Date) {
            let content = UNMutableNotificationContent()
            content.title = "Habit time! 🔥"
            content.body = "\(habitName) did you get a step today?"
            content.sound = .default
            
            // remember me at same time every day //
           
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            
            // dateMatching kısmını 'components' yapıyoruz
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: habitName, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
