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
	
    let dataModel = DataModel()
     //var person =  Person()
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    //MARK - App Delegate lifeCycle Methods
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let navigationController = window!.rootViewController as! UINavigationController
    let controller = navigationController.viewControllers[0] as! AllPeopleViewController
    controller.dataModel = dataModel
    
    //person.checkFindOrCreatePersonData()
		
        customizeAppearance()
		
		return true
	}
    func applicationDidEnterBackground(_ application: UIApplication) {
        //save state
    }
    func applicationWillTerminate(_ application: UIApplication) {
        //save state
    }
    
    
}


 







