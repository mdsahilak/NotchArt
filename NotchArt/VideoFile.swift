//
//  VideoFile.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 12/09/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class NotchArtFile {
    
    var title: String?
    var path: String
    var url: URL
    var asset: AVAsset
    var previewImage: UIImage?
    var totalDuration: Double
    var currentTime: CMTime?
    var defaultPreviewImageTime: CMTime
    var subtitleURL: URL?
    
    var isPlayable: Bool {
        return asset.isPlayable
    }
    
    var isSubtitleFile: Bool {
        if url.pathExtension == "srt" {
            return true
        } else {
            return false
        }
    }

    init(url: URL) {
        self.url = url
        
        self.path = url.path
        self.title = FileManager.default.displayName(atPath: url.deletingPathExtension().path)
        self.asset = AVAsset(url: url)
        self.totalDuration = asset.duration.seconds
        self.defaultPreviewImageTime = CMTime(seconds: totalDuration / 2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let subtitleCheckURL = url.deletingPathExtension().appendingPathExtension("srt")
        if FileManager.default.fileExists(atPath: subtitleCheckURL.path) {
            self.subtitleURL = subtitleCheckURL
        } else {
            self.subtitleURL = nil
        }
        loadPreviewImage()
    }
    
    func loadPreviewImage() {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        if let generatedImage = try? imageGenerator.copyCGImage(at: currentTime ?? defaultPreviewImageTime, actualTime: nil) {
            self.previewImage = UIImage(cgImage: generatedImage)
        } else {
            if isSubtitleFile {
                self.previewImage = UIImage(named: "CC")
            } else {
                self.previewImage = UIImage(named: "Loading")
            }
        }
    }
    
}
