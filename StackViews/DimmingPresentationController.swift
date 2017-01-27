//
//  DimmingPresentationController.swift
//  StackViews
//
//  Created by new on 7/25/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
	
  //leave the first view controller visible
  override var shouldRemovePresentersView : Bool {
    return false
  }
  
  lazy var dimmingView = GradientView(frame: CGRect.zero)
  
	
	//Delegate Method that gets called when new view is being presented by presentation controller
	// in this casew we...
  //fade in the gradient view over time
	
  override func presentationTransitionWillBegin() {
	
	
	//"containerView" is a new view that is placed on top of the AllPeopleVC and it contains the
	//views of the new view controller
	//set the size of  the graident view to the same as the super view
	dimmingView.frame = containerView!.bounds
	
	//add the gradient view as subview to the container view so that it is the
	// first view in the hierarchy of the new set of views
	containerView!.insertSubview(dimmingView, at: 0)
    
	//set the gradient view to be completely transparent
	dimmingView.alpha = 0
	
	
	// 2 things animating at the same time
	// 1. let the gradient view fade in
	// 2. at the same time that the new view bounces in
	
	if let transitionCoordinator = presentedViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: { _ in
		
		//animate it to be fully visible
		self.dimmingView.alpha = 1
      }, completion: nil)
    }
  }
  
	//Delegate method that gets called when the view is being removed
	// in this case the gradient view is being dimmed as the viewController is sliding up and away
	
	override func dismissalTransitionWillBegin()  {
    if let transitionCoordinator = presentedViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: { _ in
        self.dimmingView.alpha = 0
      }, completion: nil)
    }
  }
}
