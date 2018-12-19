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
        
        return cell
        
    }
    
    // Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerItem = AVPlayerItem(asset: notchArtFiles[indexPath.row].asset)
        player?.replaceCurrentItem(with: playerItem)
        updateVideoControlsUI()
        videoLengthSlider.maximumValue = Float(playerItem.duration.seconds)
        
    }
    
}
