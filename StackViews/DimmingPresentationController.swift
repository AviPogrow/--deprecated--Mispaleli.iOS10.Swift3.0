//
//  DimmingPresentationController.swift
//  StackViews
//
//  Created by new on 7/25/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
	
    //1. keep the view of the presenting view controller visible
    override var shouldRemovePresentersView : Bool {
    return false
  }
    
    //2. create instance of GradientView and call it dimmingView
    lazy var dimmingView = GradientView(frame: CGRect.zero)
  
	
	override func presentationTransitionWillBegin() {
	
	
	//3."containerView" is a new view that is placed on top of the AllPeopleVC and it contains the
	//views of the new view controller
	//set the size of  the graident view to the same as the super view
	dimmingView.frame = containerView!.bounds
	
        //4. add the gradient to the superView and insert it
        // behind all the other views in the container view
        containerView!.insertSubview(dimmingView, at: 0)
    
	  //5. set the gradient view to be completely transparent
	  dimmingView.alpha = 0
	
	
        //6. get a reference to the transitionCoordinator property of the
        // new view controller
	if let coordinator = presentedViewController.transitionCoordinator {
      
        //7. tell the coordinator to animate the transparency of the gradient view
        // along with the other transition animations        
        coordinator.animate(alongsideTransition: { _ in
		
		//animate it to be fully visible
		self.dimmingView.alpha = 1
      }, completion: nil)
    }
  }
  
	//Delegate method that gets called when the view is being removed
	// in this case the gradient view is being dimmed as the viewController is sliding up and away
	
	override func dismissalTransitionWillBegin()  {
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { _ in
        self.dimmingView.alpha = 0
      }, completion: nil)
    }
  }
}
