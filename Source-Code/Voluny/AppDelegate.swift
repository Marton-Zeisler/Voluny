//
//  AppDelegate.swift
//  Voluny
//


import UIKit
import CoreData
import Firebase
import GooglePlaces
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        let yourAPI = ""
        GMSPlacesClient.provideAPIKey(yourAPI)
        UIApplication.shared.statusBarStyle = .lightContent
        //UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.831372549, green: 0.2745098039, blue: 0.4196078431, alpha: 1)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -7)
        let tabBarItemApperance = UITabBarItem.appearance()
        
        // Unselected text color of tab bar
        tabBarItemApperance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 9)!, NSAttributedString.Key.foregroundColor:UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)], for: UIControl.State.normal)
        
        // Selected text Color of Tab Bar
        tabBarItemApperance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 9)!, NSAttributedString.Key.foregroundColor:UIColor.white], for: UIControl.State.selected)
        
        
        
        
//        let x = Double(UIScreen.main.bounds.width / 5.0 )
//        //let y = Double(UIScreen.main.bounds.height * 0.123) //Double(UIScreen.main.bounds.height * 0.08831521739)
//        var y = 0.0
//
//        if UIScreen.main.bounds.height == 667{ // iphone 8
//            y = 65.0
//        }else if UIScreen.main.bounds.height == 812{ // iphone x
//            y = 100.0
//        }else if UIScreen.main.bounds.height == 736{
//            y = 65.0
//        }else if UIScreen.main.bounds.height == 568{
//            y = 55.0
//        }else{
//            y = 65.0
//        }
//
//        let color = UIColor(red:0.61, green:0.17, blue:0.38, alpha:1.0)
//        let indicatorBackground: UIImage? = self.image(from: color, for: CGSize(width: x, height: y))
//        UITabBar.appearance().selectionIndicatorImage = indicatorBackground

        
        return true
    }
    
    func image(from color: UIColor, for size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        autoreleasepool {
            UIGraphicsBeginImageContext(rect.size)
        }
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack
/*
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Voluny")
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
 
 */

}

