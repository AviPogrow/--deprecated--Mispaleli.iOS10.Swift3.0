//
//  DataModel.swift
//  StackViews
//
//  Created by John Doe on 2/3/17.
//  Copyright © 2017 Avi Pogrow. All rights reserved.
//

import Foundation

class DataModel {
   
    init() {
       let person = Person()
       person.checkFindOrCreatePersonData()
        
       registerDefaults()
    }

    
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




