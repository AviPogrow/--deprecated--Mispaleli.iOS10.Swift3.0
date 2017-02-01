//
//  Person.swift
//  Tehillim119ForBubby
//
//  Created by new on 5/12/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

extension Person  {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }
	
	   @NSManaged var personName:String?
       @NSManaged var lettersInName: [LetterInName]
	   @NSManaged var dateCreated: Date?
       @NSManaged var currentKapitelIndex: Int16
    

    
	

}
