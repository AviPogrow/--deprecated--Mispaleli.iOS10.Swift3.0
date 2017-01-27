//
//  AppDelegate.swift
//  StackViews
//
//  Created by new on 6/17/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white]
        
    }
   
    lazy var sharedContext: NSManagedObjectContext = {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		addPersonEntityToContext()
        customizeAppearance()
		
		return true
	}

	func addPersonEntityToContext() {
	
       let  person1 = NSEntityDescription.insertNewObject(
        forEntityName: "Person",
        into: sharedContext) as! Person
		
		person1.personName = "Avraham Pinchus"
		
		CoreDataStackManager.sharedInstance().saveContext()
	}
}
