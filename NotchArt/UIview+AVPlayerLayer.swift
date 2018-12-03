//
//  videoPlayerView.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 18/11/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import UIKit
import AVFoundation
// Made a custom view (subclass of uiview) to set as the identity of mainView in interfaceBuilder.
//This is as per solution on stackoverflow for the problem of layer lagging when the user  changes orientation.
//site: https://stackoverflow.com/questions/10126200/avplayer-layer-inside-a-view-does-not-resize-when-uiview-frame-changes
// Solution works well. Checked.

class videoPlayerView: UIView {

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
