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
        let notchHideConstraintValue = userDefaults.double(forKey: "Notch_Hide_Constraint")
        
        if size.width / size.height > 1 {
            //LandscapeLeft or LandscapeRight
            mainViewLeadingConstraint.constant = CGFloat(notchHideConstraintValue)
            mainViewTrailingConstraint.constant = CGFloat(notchHideConstraintValue)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.layer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            } // This was added here to mitigate the problem of lightning like issue in the video layer while transitioning to landscape and changing videogravity together.
            selectedVideoGravity = AVLayerVideoGravity.resizeAspectFill
            currentAspectType = .nonNotchFill
            
            //upnextCollectionView.isHidden = false
        } else {
            //Portrait or UpsideDown
            mainViewLeadingConstraint.constant = 0.0
            mainViewTrailingConstraint.constant = 0.0
            
            layer?.videoGravity = AVLayerVideoGravity.resizeAspect
            selectedVideoGravity = AVLayerVideoGravity.resizeAspect
            currentAspectType = .original
            
            //upnextCollectionView.isHidden = true
        }
        updateViewConstraints()
    }
    
}
