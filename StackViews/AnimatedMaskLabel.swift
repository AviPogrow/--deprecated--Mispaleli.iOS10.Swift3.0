//
//  AnimatedMaskLabel.swift
//  StackViews
//
//  Created by John Doe on 5/5/17.
//  Copyright © 2017 Avi Pogrow. All rights reserved.
//


import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        // Configure the gradient here
        gradientLayer.backgroundColor = UIColor.white.cgColor
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.locations = [0.25, 0.5, 0.75]
        gradientLayer.colors = [
            UIColor.black,
            UIColor.white,
            UIColor.black
            ].map { color in color.cgColor }
        
        return gradientLayer
    }()
    
    let textAttributes: [String: AnyObject] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 28.0)!,
            NSParagraphStyleAttributeName: style
        ]
    }()
    
    func imageWithText(_ text: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        text.draw(in: bounds, withAttributes: textAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    @IBInspectable var text: String! {
        didSet {
            setNeedsDisplay()
            let image = UIGraphicsImageRenderer(size: bounds.size).image{
                _ in
                text.draw(in: bounds, withAttributes: textAttributes)
            }
            
            
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = image.cgImage
            
            gradientLayer.mask = maskLayer
        }
    }
    
    override func layoutSubviews() {
        layer.borderColor = UIColor.green.cgColor
        
        gradientLayer.frame = CGRect(
            x: -bounds.size.width,
            y: bounds.origin.y,
            width: 3 * bounds.size.width,
            height: bounds.size.height)
        
        layer.addSublayer(gradientLayer)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //create a CABasicAnimation that animates the "locations" property
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        var mask = UIImageView(image: imageWithText(text))
    }
    
}
