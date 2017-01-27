//
//  LetterInName.swift
//  StackViews
//
//  Created by John Doe on 1/25/17.
//  Copyright © 2017 Avi Pogrow. All rights reserved.
//

import Foundation
import CoreData

extension LetterInName {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LetterInName> {
        return NSFetchRequest<LetterInName>(entityName: "LetterInName");
    }
    
        @NSManaged var hebrewLetterString: String?
        @NSManaged var kapitelImageString: String?
        @NSManaged var person: Person?

}

/*
	fileprivate var inMemoryCache = NSCache<AnyObject, AnyObject>()
	
	var computedLetterImage: UIImage? {
 
 get {
 return UIImage(named: hebrewLetterString!)
 }
 
 set {
 
 storeImage(newValue, withIdentifier: hebrewLetterString!)
 }
 }
 
	
	var computedKapitelImage: UIImage? {
 
 get {
 return UIImage(named: kapitelImageString!)
 }
 
 set {
 storeImage(newValue, withIdentifier: kapitelImageString!)
 }
 }
	
	
	// MARK: - Saving images to the memory cache and docs directory using the string identifier
 
 func storeImage(_ image: UIImage?, withIdentifier identifier: String) {
 
 let path = pathForIdentifier(identifier)
 
 // If the image is nil, remove images from the cache
 if image == nil {
 inMemoryCache.removeObject(forKey: path as AnyObject)
 
 do {
 try FileManager.default.removeItem(atPath: path)
 } catch _ {}
 
 return
 }
 
 // Otherwise, push the image into memory (NSCache)
 inMemoryCache.setObject(image!, forKey: path as AnyObject)
 
 // And in push image into documents directory
 let data = UIImagePNGRepresentation(image!)!
 try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
 }
	// MARK: - Helper
 
 func pathForIdentifier(_ identifier: String) -> String {
 let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
 let fullURL = documentsDirectoryURL.appendingPathComponent(identifier)
 
 return fullURL.path
 }
	
	*/
