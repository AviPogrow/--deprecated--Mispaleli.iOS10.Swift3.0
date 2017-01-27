//
//  PersonCell.swift
//  StackViews
//
//  Created by new on 7/10/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

	override func awakeFromNib() {
    super.awakeFromNib()
	
	//self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0
	self.layer.cornerRadius = 10.0
	
	self.layer.borderWidth = 0.45
	self.layer.borderColor = UIColor.red.cgColor
	
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
		let selectionView = UIView(frame: self.bounds)
    	selectionView.backgroundColor = UIColor.yellow
    	selectedBackgroundView = selectionView
	}
	
	func drawTheLetters() {
	}
	
	override func prepareForReuse() {
	
	  for v in contentView.subviews {
			v.removeFromSuperview()
        }
    }
}
