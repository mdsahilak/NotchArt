//
//  ViewController++.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 16/12/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController {
    
    func pauseVideo() {
        player?.pause()
        isPlaying = false
    }
    
    func playVideo() {
        player?.play()
        isPlaying = true
    }
    
    func initializeVideoPlayerWithVideo() {
        
        // initialize the video player with the url
        self.player = AVPlayer(url: selectedNotchArtFile.url)
        
        // create a video layer for the player
        //layer = AVPlayerLayer(player: player)
        
        // add the layer to the container view
        //mainView.layer.addSublayer(layer)
        
        self.layer = mainView.layer as? AVPlayerLayer
        self.layer?.player = self.player
    }
    
    func updatePLayerLayerToUI() {
        // make the layer the same size as the container view
        //layer?.frame = mainView.bounds
        
        // make the video fill the layer as much as possible while keeping its aspect size
        layer?.videoGravity = selectedVideoGravity
        
        // Make the side black bars dissappear in case of portrait mode by updating constraints
        setSideConstraints(size: view.frame.size)
    }
    
    
}
