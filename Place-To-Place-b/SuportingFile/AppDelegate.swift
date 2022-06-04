//
//  AppDelegate.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import UIKit
import CoreData
import Firebase
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    let messagingDeleget = Messaging.messaging()
    static let shared = AppDelegate()
    var user: Users!
    let natificationCenter = UNUserNotificationCenter.current()
    let notifications = Notifications()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        
        
        if let users = Auth.auth().currentUser {
            let user = Users(user: users)
            FirebaseData.shared.getUserData(user: user) { (result) in
                switch result {
                case .success(let muser):
                    self.user = muser
                case .failure(_): break
                }
            }
        }
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                FirebaseData.shared.userData(token: token)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        print("Authorized")
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                })
            } else {
                //you got permission to track, iOS 14 is not yet installed
            }
        }
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestDataPermission()
    }
    func requestDataPermission() {
       
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data) {
            
            let tokenParts = deviceToken.map { data -> String in
                return String(format: "%02.2hhx", data)
            }
            
            let token = tokenParts.joined()
            print("Device token: \(token)")
        }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError
        error: Error) {
            
            print("Failed to register: \(error)")
        }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Place_To_Place_b")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken  else {return}
        FirebaseData.shared.userData(token: fcmToken)
        print("Token Firebase devise: \(fcmToken)")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
}
