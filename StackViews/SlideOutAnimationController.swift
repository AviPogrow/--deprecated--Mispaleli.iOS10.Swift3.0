//
//  SlideOutAnimationController.swift
//  StackViews
//
//  Created by new on 7/26/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
	
  //1 set the time for the animation
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.3
  }
  
	
 //2
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
	
	
    if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
		
	    _ = transitionContext.containerView

		
		//call the method that returns the duration defined in the first function
		// and set the duration variable
		let duration = transitionDuration(using: transitionContext)
		
	   	UIView.animate(withDuration: duration, animations: {
		
		//scale it down to half its size
		fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
		
		//take the view's center position and subtract the height of the screen
		//fromView.center.y -= containerView.bounds.size.height
			
		
		
	   }, completion: { finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}
