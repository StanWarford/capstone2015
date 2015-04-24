//
//  AppDelegate.swift
//  capstone2015
//
//  Created by Adam Inglehart on 1/12/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData
import Parse

//Declaring Global Variables that are accessible throughout the App

var classDict: JSON?
var classList: [JSON] = []
var deptOfInterest: String?
var courseOfInterest: String?
let url = "http://137.159.47.86:8181/classes"
let serverUrl = "http://137.159.47.86:8181/subscribe"
let parameters = [
    "user":"jtmontoy",
    "type":"iOS",
    "token":"IJ0IQJPR9mKRR2zODGiLjzeC6eeXyBZpn8KqaVE8"
]
let pepperdineOrange = UIColor.orangeColor()
let pepperdineGray = UIColor.grayColor()
let pepperdineLightGray = UIColor(white: 0.9, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // programmatically set initial view controller
//        
//        // Subscribe push notifications with Node-pushServer
//        request(.POST, serverUrl, parameters: parameters)
//            .responseString { (_, _, string, _) in
//                println(string)
//        }
        
        Parse.setApplicationId("68AsOzImcf5xygN68CpXl0VFYQhak7o8X75D0Soa", clientKey: "IJ0IQJPR9mKRR2zODGiLjzeC6eeXyBZpn8KqaVE8")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
            Parse.setApplicationId("68AsOzImcf5xygN68CpXl0VFYQhak7o8X75D0Soa",
                clientKey: "IJ0IQJPR9mKRR2zODGiLjzeC6eeXyBZpn8KqaVE8")
            PFUser.enableAutomaticUser()
            
            var defaultACL = PFACL()
            // If you would like all objects to be private by default, remove this line.
            defaultACL.setPublicReadAccess(true)
            PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
            
            return true
        }
        
     
        UINavigationBar.appearance().barTintColor = UIColor(red: 13.0/255, green: 36.0/255,blue: 109.0/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Settings]
        if fetchResults?.count > 0 {
            var intialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Classes") as! UITabBarController
            self.window?.rootViewController = intialViewController
        } else {
            var intialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Introduction") as! UINavigationController
            self.window?.rootViewController = intialViewController
        }
        self.window?.makeKeyAndVisible()
       
        // asynchronous alamofire get request
        request(.GET, url, parameters: nil)
            .responseJSON { (req, res, json, error) in
                if (error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(url)")
                    classDict = JSON(json!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        for dept in classDict!.dictionary!.keys.array { // ["COSC", "HUM", ...]
                            for course in classDict![dept].dictionary!.keys.array { // ["COSC 101", "COSC 105", ...]
                                for section in classDict![dept][course].dictionary!.keys.array { // ["COSC 101.01", "COSC 101.02"]
                                    classList.append(classDict![dept][course][section])
                                }
                            }
                        }
                        print(classList)
                    }
                    
                }
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.PeppCompSci.capstone2015" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("capstone2015", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("capstone2015.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dic as! [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

