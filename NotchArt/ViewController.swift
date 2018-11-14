//
//  ViewController.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 22/08/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox
import LocalAuthentication

class ViewController: UIViewController {
    
    var selectedVideoPath: String?
    var player: AVPlayer?
    var layer: AVPlayerLayer!
    var selectedVideoGravity = AVLayerVideoGravity.resizeAspectFill
    
    var videoAsset: AVAsset?
    var videoDuration: Double?
    var updateUITimer: Timer!
    var eyeHealthTimer: Timer!
    
    var faceIDAvailable: Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                playPauseButton.setImage(UIImage(named: "pause")!, for: .normal)
                
            } else {
                playPauseButton.setImage(UIImage(named: "play")!, for: .normal)
                
            }
        }
    }
    
    var showVideoControls: Bool = true {
        didSet {
            if showVideoControls == false {
                UIView.animate(withDuration: 0.5) {
                    self.videoLengthSlider.alpha = 0
                    self.videoLengthSlider.isUserInteractionEnabled = false
                    
                    self.timeElapsedLabel.alpha = 0
                    self.timeRemainingLabel.alpha = 0
                    
                    self.muteButton.alpha = 0
                    
                    self.playPauseButton.alpha = 0
                    self.playPauseButton.isUserInteractionEnabled = false
                    
                    self.dismissButton.alpha = 0
                }
                
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.videoLengthSlider.alpha = 1
                    self.videoLengthSlider.isUserInteractionEnabled = true
                    
                    self.timeElapsedLabel.alpha = 1
                    self.timeRemainingLabel.alpha = 1
                    
                    self.muteButton.alpha = 1
                    
                    self.playPauseButton.alpha = 1
                    self.playPauseButton.isUserInteractionEnabled = true
                    
                    self.dismissButton.alpha = 1
                }
                
            }
        }
    }
    
    var isMuted: Bool = false{
        didSet {
            if isMuted == true {
                player?.isMuted = true
                muteButton.setTitle("🔈", for: .normal)
            } else {
                player?.isMuted = false
                muteButton.setTitle("🔇", for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var videoLengthSlider: UISlider!
    @IBOutlet weak var muteButton: UIButton!
    
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //To make the player container view corners curved on true depth available devices.
        /*
        if faceIDAvailable == true{
            mainView.layer.cornerRadius = 11
            mainView.clipsToBounds = true
            mainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            print("Device has faceID")
            imageView.layer.cornerRadius = 44.0
            imageView.clipsToBounds = true
            
        } else {
            print("Device does not have faceID")
        }
        */
        initializeVideoPlayerWithVideo()
        
        videoAsset = player?.currentItem?.asset
        videoDuration = videoAsset?.duration.seconds
        
        videoLengthSlider.minimumValue = 0.00
        videoLengthSlider.maximumValue = Float(videoDuration!)
        videoLengthSlider.isContinuous = true
        videoLengthSlider.layer.cornerRadius = 16.0
        videoLengthSlider.clipsToBounds = true
        videoLengthSlider.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        timeElapsedLabel.layer.cornerRadius = 5.0
        timeElapsedLabel.clipsToBounds = true
        timeElapsedLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        timeRemainingLabel.layer.cornerRadius = 5.0
        timeRemainingLabel.clipsToBounds = true
        timeRemainingLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        playPauseButton.layer.cornerRadius = 5.0
        playPauseButton.clipsToBounds = true
        playPauseButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Subtitling Sample Code --Delete after use
        if let group = videoAsset?.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible) {
            let locale = Locale(identifier: "es-ES")
            let options =
                AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
            if let option = options.first {
                // Select Spanish-language subtitle option
                player?.currentItem?.select(option, in: group)
            }
        }
        // Subtitling -- delete after use!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUITimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateVideoControlsUI), userInfo: nil, repeats: true)
    }
    
    override func viewWillLayoutSubviews() {
        //This part of updating the AV player and player layer is called here, so as to make the player Layer adhere to the mainView's constraints.
        updatePLayerLayerToUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if player?.currentItem?.asset.isPlayable == false {
            let alertController = UIAlertController(title: "Oops!", message: "Sorry, This format is not supported at the moment, Please check back later", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            playVideo()
        }
        
        eyeHealthTimer = Timer.scheduledTimer(timeInterval: 20*60 + 25, target: self, selector: #selector(eyeHealthTimerCalled), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateUITimer.invalidate()
    }
    
    
    @objc func appWillResignActive() {
        print("AppWillResginActive - called.")
        pauseVideo()
    }
    
    @objc func updateVideoControlsUI() {
        videoLengthSlider.setValue(Float((player?.currentItem?.currentTime().seconds)!), animated: true)
        let currentTime = player?.currentTime().seconds
        // h,m,s stands for hours, minutes and seconds. // E is for Elapsed and R is for Remaining.
        let (hE, mE, sE) = secondsToHoursMinutesSecondsString(seconds: Int(currentTime!))
        timeElapsedLabel.text = "\(hE):\(mE):\(sE)"
        let (hR, mR, sR) = secondsToHoursMinutesSecondsString(seconds: Int(videoDuration! - currentTime!))
        timeRemainingLabel.text = "-\(hR):\(mR):\(sR)"
    }
    
    @objc func eyeHealthTimerCalled() {
        pauseVideo()
        
        let alertController = UIAlertController(title: "20-20-20 Rule", message: "Every 20 minutes look at something 20 feet away for 20 seconds. This feature helps prevent eye strain and related problems. We'll tap you when your ready!", preferredStyle: .alert)
        let impactGen = UIImpactFeedbackGenerator(style: .heavy)
        
        impactGen.impactOccurred()
        present(alertController, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(21), execute: {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                self.dismiss(animated: true, completion: { self.playVideo() })
            })
            
        }
    }
    
    func pauseVideo() {
        player?.pause()
        isPlaying = false
    }
    
    func playVideo() {
        player?.play()
        isPlaying = true
    }
    
    func initializeVideoPlayerWithVideo() {
        
        // get the path string for the video from assets
        // this is already available in the variable selectedVideoPath as it was passed from the previous view controller.
        
        guard let unwrappedVideoPath = selectedVideoPath else { print("Error! could not unwrap the given path!")
            return }
        
        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        
        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl)
        
        // create a video layer for the player
        layer = AVPlayerLayer(player: player)
        
        // add the layer to the container view
        mainView.layer.addSublayer(layer)
        
    }
    
    func updatePLayerLayerToUI() {
        // make the layer the same size as the container view
        layer.frame = mainView.bounds
        
        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = selectedVideoGravity
        
    }
    
    
    // ---------- Implementations For Player Controls. --------- //
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if self.isPlaying {
            player?.pause()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else {
            player?.play()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        self.isPlaying = !self.isPlaying
        /*
        UIView.animate(withDuration: 0.2, animations: {
            self.playPauseButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (true) in
            self.playPauseButton.transform = CGAffineTransform.identity
        }
        */
    }
    
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        isMuted = !isMuted
    }
    
    
    var userWasPlaying: Bool?
    @IBAction func touchedDownOnSlider(_ sender: UISlider) {
        if isPlaying == true{
            pauseVideo()
            userWasPlaying = true
        } else {
            userWasPlaying = false
        }
    }
    @IBAction func videoSliderValueChanged(_ sender: UISlider) {
        player?.seek(to: CMTime(seconds: Double(sender.value), preferredTimescale: 1))
    }
    @IBAction func releasedSliderMethods(_ sender: UISlider) {
        if userWasPlaying == true{
            playVideo()
        }
    }
    
    
    @IBAction func videoScreenTapped(_ sender: UITapGestureRecognizer) {
            showVideoControls = !showVideoControls
    }
    
    
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        player?.seek(to: CMTime(seconds: (player?.currentTime().seconds)! + 10.0, preferredTimescale: 1))
    }
    
    
    @IBAction func swipedLeft(_ sender: UISwipeGestureRecognizer) {
        player?.seek(to: CMTime(seconds: (player?.currentTime().seconds)! - 10.0, preferredTimescale: 1))
    }
    
    
    @IBAction func swipedUp(_ sender: UISwipeGestureRecognizer) {
        //UIScreen.main.brightness += 0.1
    }
    
    
    @IBAction func swipedDown(_ sender: UISwipeGestureRecognizer) {
        //UIScreen.main.brightness -= 0.1
        performSegue(withIdentifier: "DismissToListView", sender: nil)
    }
    
    
    @IBAction func videoScreenPiched(_ sender: UIPinchGestureRecognizer) {
        if sender.scale > 1.00 {
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            selectedVideoGravity = AVLayerVideoGravity.resizeAspectFill
        } else if sender.scale < 1.00 {
            layer.videoGravity = AVLayerVideoGravity.resizeAspect
            selectedVideoGravity = AVLayerVideoGravity.resizeAspect
        } else {
            print("Error@ videoScreenPiched(...) IBAction Method !")
        }
    }
 
    // --- Player Controls Implementation Over! --- //
    
    func secondsToHoursMinutesSecondsString (seconds : Int) -> (String, String, String) {
        let hrs = String(seconds / 3600)
        let mins = String(format: "%02d", (seconds % 3600) / 60)
        let secs = String(format: "%02d", (seconds % 3600) % 60)
        
        return (hrs, mins, secs)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

