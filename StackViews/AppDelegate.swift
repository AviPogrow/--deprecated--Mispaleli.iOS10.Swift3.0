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
	
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["PersonIndex": -1]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "PersonIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PersonIndex")
            UserDefaults.standard.synchronize()
        }
    }
   
   
    //MARK - App Delegate lifeCycle Methods
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    var person =  Person()
    
    person.checkFindOrCreatePersonData()
		
        customizeAppearance()
		
		registerDefaults()
        
        return true
	}
    
    
}


 







