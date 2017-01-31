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

    var person =  Person()
    
    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white]
        
    }
   
    lazy var sharedContext: NSManagedObjectContext = {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()

    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		insertSampleData()
        customizeAppearance()
		
		person.registerDefaults()
        
        return true
	}
    
  
    
    
    func insertSampleData() {
	
        //create a fetch request of object "Person"
        let fetch =  NSFetchRequest<Person>(entityName: "Person")
        
        let count = try! sharedContext.count(for: fetch)
        
        if count > 0 {
            return
        }
        
        let  person1 = NSEntityDescription.insertNewObject(
        forEntityName: "Person",
        into: sharedContext) as! Person
		
		person1.personName = "Avraham Pinchus"
		
		CoreDataStackManager.sharedInstance().saveContext()
        }
    }

 







