//
//  Person.swift
//  StackViews
//
//  Created by John Doe on 1/25/17.
//  Copyright © 2017 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

public class Person: NSManagedObject {
    
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
}
