//
//  Notifications.swift
//  Place-To-Place
//
//  Created by СОВА on 20.06.2021.
//

import Foundation

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    func requestAutorization() {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func scheduleNotification(notifaicationType: String) {

        let content = UNMutableNotificationContent()
        let userActions = "User Actions"

        content.title = notifaicationType
        content.body = "This is example how to create " + notifaicationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions

        guard let path = Bundle.main.path(forResource: "favicon", ofType: "png") else { return }

        let url = URL(fileURLWithPath: path)

        do {
            let attachment = try UNNotificationAttachment(
                identifier: "favicon",
                url: url,
                options: nil)

            content.attachments = [attachment]
        } catch {
            print("The attachment cold not be loaded")
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }

        let snoozeAction = UNNotificationAction(
            identifier: "Snooze",
            title: "Snooze",
            options: [])

        let deleteAction = UNNotificationAction(
            identifier: "Delete",
            title: "Delete",
            options: [.destructive])

        let category = UNNotificationCategory(
            identifier: userActions,
            actions: [snoozeAction, deleteAction],
            intentIdentifiers: [],
            options: [])

        notificationCenter.setNotificationCategories([category])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the Local Notification Identifire")
        }

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notifaicationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }

        completionHandler()
    }

}



