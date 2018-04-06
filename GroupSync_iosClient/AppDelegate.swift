//
//  AppDelegate.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import AWSCore
import AWSS3

let sendLocation = SendLocation()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,  UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    let userInfo = UserDefaults.standard

    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
    
        
        return true
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
        
        let accessKey = "AKIAIHFI54OFAWCCER2A"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
       
        
        
        
        registerForPushNotifications()
        
        if #available(iOS 10.0, *)
        {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert])          { (granted, error) in
                if granted
                {
                    //self.registerCategory()
                }
            }
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        }
        else
        {
            let settings: UIUserNotificationSettings =  UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        //Configuring Firebase
        FirebaseApp.configure()
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        return true
    }
   
    
    //Receive Remote Notification on Background
   private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }

    @objc func tokenRefreshNotification(notification: NSNotification)
    {
        if let refreshedToken = InstanceID.instanceID().token()
        {
            print("InstanceID token: \(refreshedToken)")
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm()
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        connectToFcm()
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token first time: \(fcmToken)")
        
        userInfo.set(fcmToken, forKey: "fcmToken")
        userInfo.synchronize()
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

 
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("entered Background")

    }
    func sendPost()
    {
        print("sendPost")
        sendLocation.determineCurrentLocation()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
   

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token refreshed: (fcmToken)")
    
    Messaging.messaging().shouldEstablishDirectChannel = true
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: (remoteMessage.appData)")
}
}
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            
            guard granted else {return}
            self.getNotificationSettings()
        }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else {return}
            DispatchQueue.main.async {
            
            UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        userInfo.set(token, forKey: "deviceToken")
        userInfo.synchronize()
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

