//
//  videoTableViewCell.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 15/11/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class videoTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageVIew.layer.borderWidth = 7
        imageVIew.layer.borderColor = UIColor.black.cgColor
        
        imageVIew.layer.cornerRadius = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(videoFilePath: String) {
        
    }
    
}
