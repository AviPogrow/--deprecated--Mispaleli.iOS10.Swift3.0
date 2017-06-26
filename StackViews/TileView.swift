//
//  TileView.swift
//  StackViews
//
//  Created by new on 8/12/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

//
//  TileView.swift
//  Anagrams
//
//  Created by Caroline Begbie on 12/04/2015.
//  Copyright (c) 2015 Caroline. All rights reserved.
//

import Foundation
import UIKit

class TileView:UIImageView {

fileprivate var tempTransform: CGAffineTransform = CGAffineTransform.identity
  
  // this should never be called
  required init?(coder aDecoder:NSCoder) {
    fatalError("use init(letter:, sideLength:")
  }
  
  // create a new tile for a given letter
  init(letter:String, sideLength:CGFloat) {
    
    //the tile background
    let image = UIImage(named: letter)!
    
        super.init(image:image)
    
        let scale = sideLength / image.size.width
	
	self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
    }
    
/*
	//add a letter on top
    let letterLabel = UILabel(frame: self.bounds)
    letterLabel.textAlignment = NSTextAlignment.Center
    letterLabel.textColor = UIColor.whiteColor()
    letterLabel.backgroundColor = UIColor.clearColor()
    letterLabel.text = String(letter).uppercaseString
    letterLabel.font = UIFont(name: "Verdana-Bold", size: 78.0*scale)
    self.addSubview(letterLabel)
    
    self.userInteractionEnabled = true
    
    */
    func addLayerEffect() {
	self.layer.borderWidth = 0.8
	self.layer.borderColor = UIColor.gray.cgColor
	
    /*
	//create the tile shadow
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOpacity = 0.25
    self.layer.shadowOffset = CGSize(width: 1.5,height: 1.5)
    self.layer.shadowRadius = 0.25
    self.layer.masksToBounds = false
    
    let path = UIBezierPath(rect: self.bounds)
    self.layer.shadowPath = path.cgPath
 */
    }
}
  
 
  


