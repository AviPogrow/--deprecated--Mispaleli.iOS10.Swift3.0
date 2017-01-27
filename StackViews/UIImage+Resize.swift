//
//  UIImage+Resize.swift
//  StackViews
//
//  Created by new on 7/7/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

extension UIImage {
  func resizedImageWithBounds(_ bounds: CGSize) -> UIImage {
    let horizontalRatio = bounds.width / size.width
    let verticalRatio = bounds.height / size.height
    let ratio = min(horizontalRatio, verticalRatio)
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    
    UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
    draw(in: CGRect(origin: CGPoint.zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }

 func imageForHud(_ image:UIImage) -> UIImage {
	
	
      return image.resizedImageWithBounds(CGSize(width: 13, height: 13))
    
  }
}
