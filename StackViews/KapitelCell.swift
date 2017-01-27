//
//  KapitelCell.swift
//  StackViews
//
//  Created by new on 8/18/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//


import UIKit

class KapitelCell: UITableViewCell {

	override func awakeFromNib() {
    	super.awakeFromNib()
	
		self.layer.cornerRadius = 10.0
	    self.layer.borderWidth = 1.45
		self.layer.borderColor = UIColor.red.cgColor
	}
	
	override func prepareForReuse() {
        for v in contentView.subviews {
			v.removeFromSuperview()
        }
	  }
   }
