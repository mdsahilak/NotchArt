//
//  ViewController+Collectionview.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 02/12/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notchArtFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upnextCell", for: indexPath) as? upnextCollectionViewCell else {return UICollectionViewCell()}
        
        cell.imageView.image = notchArtFiles[indexPath.row].previewImage
        cell.titleLabel.text = notchArtFiles[indexPath.row].title
        
        if indexPath == selectedFileIndexPath {
            cell.isUserInteractionEnabled = false
            cell.alpha = 0.33
        } else {
            cell.isUserInteractionEnabled = true
            cell.alpha = 1
        }
        
        return cell
        
    }
    
    // Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // save current item
        selectedNotchArtFile.currentTime = player?.currentTime()
        selectedNotchArtFile.loadPreviewImage()
        // Replace the player's item
        let newNotchFile = notchArtFiles[indexPath.row]
        let playerItem = AVPlayerItem(asset: newNotchFile.asset)
        player?.replaceCurrentItem(with: playerItem)
        // Update view controller State(fast)
        updateVideoControlsUI()
        videoLengthSlider.maximumValue = Float(playerItem.duration.seconds)
        // Update view controller variables
        selectedNotchArtFile = newNotchFile
        selectedFileIndexPath = indexPath
        videoAsset = newNotchFile.asset
        videoDuration = newNotchFile.totalDuration
        // Update the array for reloading indexpaths
        if indexPathsForPlayedItems.contains(indexPath) == false {
            indexPathsForPlayedItems.append(indexPath)
        }
        //Last
        collectionView.reloadData()
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
