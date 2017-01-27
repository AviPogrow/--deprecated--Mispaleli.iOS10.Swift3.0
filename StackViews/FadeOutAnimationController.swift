//
//  FadeOutAnimationController.swift
//  StackViews
//
//  Created by new on 7/28/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 2.0
  }
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
      let duration = transitionDuration(using: transitionContext)
      UIView.animate(withDuration: duration, animations: {
        fromView.alpha = 0
      }, completion: { finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}
