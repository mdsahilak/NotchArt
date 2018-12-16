//
//  ViewController+Misc.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 16/12/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController {
    
    func secondsToHoursMinutesSecondsString (seconds : Int) -> (String, String, String) {
        let hrs = String(seconds / 3600)
        let mins = String(format: "%02d", (seconds % 3600) / 60)
        let secs = String(format: "%02d", (seconds % 3600) % 60)
        
        return (hrs, mins, secs)
    }
    
    func setSideConstraints(size: CGSize) {
        
        if size.width / size.height > 1 {
            //LandscapeLeft or LandscapeRight
            mainViewLeadingConstraint.constant = 30.0
            mainViewTrailingConstraint.constant = 30.0
            
            layer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            selectedVideoGravity = AVLayerVideoGravity.resizeAspectFill
            
            //upnextCollectionView.isHidden = false
        } else {
            //Portrati or UpsideDown
            mainViewLeadingConstraint.constant = 0.0
            mainViewTrailingConstraint.constant = 0.0
            
            layer?.videoGravity = AVLayerVideoGravity.resizeAspect
            selectedVideoGravity = AVLayerVideoGravity.resizeAspect
            
            //upnextCollectionView.isHidden = true
        }
        updateViewConstraints()
    }
    
}
