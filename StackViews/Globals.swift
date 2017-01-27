//
//  Functions.swift
//  StackViews
//
//  Created by new on 7/27/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//
import UIKit 
import Dispatch

func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
  let when = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
  DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

//UI Constants
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height




	
	
			

















																																												
