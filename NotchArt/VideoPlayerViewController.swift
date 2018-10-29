//
//  VideoPlayerViewController.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 14/09/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import UIKit
import AVKit
import WebKit

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var myWebView: WKWebView!
    
    var videoPaths = [String]()
    let simulatorVideoPath = "/Users/MuhammedSahil/Movies/Neymar Skills @ JN.mp4"
    let youtubeVideoPath = "https://www.youtube.com/watch?v=_WOwOVNEfzY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        videoContainerView.layer.cornerRadius = 44.0
        videoContainerView.clipsToBounds = true
        
        loadVideosFromDocumentsDir()
        
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let videoURL = URL(string: youtubeVideoPath)
        let player = AVPlayer(url: videoURL!)
        
        let controller = AVPlayerViewController()
        controller.player = player
        //present(controller, animated: true, completion: nil)
        //player.play()
        /*
        controller.view.frame = videoContainerView.bounds
        controller.videoGravity = convertToAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill.rawValue)
        controller.showsPlaybackControls = true
        self.addChild(controller)
        self.videoContainerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        player.play()
        */
        /*
        controller.view.frame = videoContainerView.frame
        self.addChildViewController(controller)
        self.videoContainerView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        player.play()
        */
        let urlRequest = URLRequest(url: videoURL!)
        self.myWebView.load(urlRequest)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadVideosFromDocumentsDir() {
        let documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        guard let DocumentDirectoryVideoNames = try? FileManager.default.subpathsOfDirectory(atPath: documentsDirectoryPath)
            else { return }
        
        for videoName in DocumentDirectoryVideoNames {
            let path = documentsDirectoryPath + "/" + videoName
            videoPaths.append(path)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToAVLayerVideoGravity(_ input: String) -> AVLayerVideoGravity {
	return AVLayerVideoGravity(rawValue: input)
}
