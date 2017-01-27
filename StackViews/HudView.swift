//
//  HudView.swift
//  StackViews
//
//  Created by new on 7/26/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

	//1. We are extending UIView and making a custom view called HudView
	class HudView: UIView {
		
		//2. setup a text property and set the text property to an empty string
		var text = ""
		
		
		//3. class method takes in a view object and returns a special "HudView"
		class func hudInView(_ view:UIView, animated: Bool) -> HudView {
		
			//4. initialize the UIView: HudView using the frame constructer
			// and pass in the view.bounds as the size of the frame
			let hudView = HudView(frame: view.bounds)
			
			//5. set the opaque property to false to make it transparent
			hudView.isOpaque = false
			
			//6, add the hudView to the superview
			view.addSubview(hudView)
			
			//7. disable user interaction
			view.isUserInteractionEnabled = false
			
			//8. use the red color to see the full size of the hud view covering the whole screen
			//hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
			
			//9. call the helper method show animated to
			//this call a uiview animation method
			hudView.showAnimated(animated)
			
			return hudView
		
		}

  // the hudview covers the whole screen but we 
  // will draw a rounded rectangle in the middle of the hudview
  override func draw(_ rect: CGRect) {
	
	// the rectangle will be 96  X 96 so it will be a rounded square
	let boxWidth: CGFloat = 96
    let boxHeight: CGFloat = 96
	
	// on top of the width and height we need to give 
	// it an x and y position
	// 
	 let boxRect = CGRect(
      x: round((bounds.size.width - boxWidth) / 2),
      y: round((bounds.size.height - boxHeight) / 2),
      width: boxWidth,
      height: boxHeight)
	
	let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
    UIColor(white: 0.3, alpha: 0.8).setFill()
    roundedRect.fill()
	
	
	 if let image = UIImage(named: "Checkmark") {
      let imagePoint = CGPoint(
        x: center.x - round(image.size.width / 2),
        y: center.y - round(image.size.height / 2) - boxHeight / 8)
      
      image.draw(at: imagePoint)
		
	 }
    
    let attribs = [ NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                    NSForegroundColorAttributeName: UIColor.white ]
    
    let textSize = text.size(attributes: attribs)
    
    let textPoint = CGPoint(
      x: center.x - round(textSize.width / 2),
      y: center.y - round(textSize.height / 2) + boxHeight / 4)
    
    text.draw(at: textPoint, withAttributes: attribs)
  }
	  func showAnimated(_ animated: Bool) {
   		 if animated {
				
		  alpha = 0
		  //transform = CGAffineTransformMakeScale(3.3, 3.3)
		  transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
				
	  
	  UIView.animate(withDuration: 2.3, delay: 0, usingSpringWithDamping: 0.7,
	  	initialSpringVelocity: 3.5,
	   		options: [], animations: {
        	self.alpha = 1
       		 self.transform = CGAffineTransform.identity
     		 },
     	 completion: nil)
   		 }
  }
}
		



















