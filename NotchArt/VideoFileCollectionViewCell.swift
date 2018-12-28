//
//  VideoFileCollectionViewCell.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 25/12/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import UIKit

class VideoFileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Custom Set up
        imageView.layer.borderWidth = 7
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 7
        
        //titleLabel.layer.cornerRadius = 7
        
        if isSelected {
            self.backgroundColor = UIColor.darkGray
        } else {
            self.backgroundColor = UIColor.clear
        }
        
        //titleLabel.backgroundColor = UIColor.black
        //titleLabel.layer.cornerRadius = 13
        //self.selectedBackgroundView?.backgroundColor = UIColor.darkGray
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 7
    }
    
}
