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
    
    /*
    var imageStringArray =
        
        ["YudLetter","ChesLetter","YudLetter","AlephLetter","LamedLetter","SpaceLetter",
         "BeisLetter","NunLetter","TzaddikLetter","YudLetter","VovLetter",
         "NunSofitLetter","SpaceLetter","BeisLetter","NunSofitLetter","SpaceLetter",
         "MemLetter","YudLetter","RayshLetter","LamedLetter"]
    
    */
    /*
    func addPersonToCoreDataUsingStringArray(_ imageStringArray:[String]) {
        
        var person = Person(context: sharedContext)
        person.dateCreated = Date()
        person.currentKapitelIndex = 101
        
        
        CoreDataStackManager.sharedInstance().saveContext()
        
        for i in imageStringArray {
            let newString = i
            let newKapitelString = i + "Kapitel"
            
            print("\(newString) and \(newKapitelString)")
            
            var letter = LetterInName(context: sharedContext)
            letter.hebrewLetterString = "\(newString)"
            letter.kapitelImageString = "\(newString)" + "Kapitel"
            
            letter.person = person
            
            CoreDataStackManager.sharedInstance().saveContext()
            print("the current state of person is \(person.debugDescription)")
        }
    } */
}
