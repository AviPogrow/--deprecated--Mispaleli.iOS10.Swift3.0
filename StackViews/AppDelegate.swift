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
    
    var imageStringArray =
        
   ["YudLetter","ChesLetter","YudLetter","AlephLetter","LamedLetter","SpaceLetter",
    "BeisLetter","NunLetter","TzaddikLetter","YudLetter","VovLetter",
    "NunSofitLetter","SpaceLetter","BeisLetter","NunSofitLetter","SpaceLetter",
    "MemLetter","YudLetter","RayshLetter","LamedLetter"]
    
    func checkIfWeHaveData() {
        
        //create a fetch request of object "Person"
        let fetch =  NSFetchRequest<Person>(entityName: "Person")
        
        let count = try! sharedContext.count(for: fetch)
        
        if count > 0 {
            return
        
        } else {
            
        var person = Person(context: sharedContext)
        
        person.addPersonToCoreDataUsingStringArray(person: person,imageStringArray)
        }
    }
    
   
    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white]
        
    }
   
    

    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

       
        checkIfWeHaveData()
		
        customizeAppearance()
		
		registerDefaults()
        
        return true
	}
    
}


 







