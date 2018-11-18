//
//  VideoFilesTableViewController.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 12/09/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import UIKit
import AVFoundation

class VideoFilesTableViewController: UITableViewController {
    
    var videoPaths: [String] = []
    var videoAssetImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideosFromDocumentsDir()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //
        loadVideoAssetImages()
        //
    }
 
    @objc func refresh() {
        let documentsDirChanged = documentDirDidChange()
        
        if documentsDirChanged == true {
            videoPaths.removeAll()
            videoAssetImages.removeAll()
            loadVideosFromDocumentsDir()
            loadVideoAssetImages()
            tableView.reloadData()
        }
        self.tableView.refreshControl?.endRefreshing()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
//            self.tableView.refreshControl?.endRefreshing()
//        }
        
    }
    
    func loadVideosFromDocumentsDir() {
        let documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        print(documentsDirectoryPath)
        
        guard let DocumentDirectoryVideoNames = try? FileManager.default.subpathsOfDirectory(atPath: documentsDirectoryPath)
            else { return }
        
        for videoName in DocumentDirectoryVideoNames {
            let path = documentsDirectoryPath + "/" + videoName
            videoPaths.append(path)
        }
    }
    
    func documentDirDidChange() -> Bool? {
        var newVideoPaths: [String] = []
        
        let documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        guard let DocumentDirectoryVideoNames = try? FileManager.default.subpathsOfDirectory(atPath: documentsDirectoryPath)
            else { return nil }
        for videoName in DocumentDirectoryVideoNames {
            let path = documentsDirectoryPath + "/" + videoName
            newVideoPaths.append(path)
        }
        
        if newVideoPaths != videoPaths {
            return true
        } else {
            return false
        }
    }
    
    func loadVideoAssetImages() {
        for path in videoPaths {
            let videoURL = URL(fileURLWithPath: path)
            let videoAsset = AVAsset(url: videoURL)
            //videosAssets.append(videoAsset)
            
            let imageGen = AVAssetImageGenerator(asset: videoAsset)
            if let cgImage = try? imageGen.copyCGImage(at: CMTime.init(seconds: (videoAsset.duration.seconds / 2), preferredTimescale: CMTimeScale(NSEC_PER_SEC)), actualTime: nil) {
                let uiImage = UIImage(cgImage: cgImage)
                videoAssetImages.append(uiImage)
            } else {
                videoAssetImages.append(UIImage(named: "Jeep")!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videoPaths.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoFileCellIdentifier", for: indexPath) as? videoTableViewCell else { return UITableViewCell()}
        /*
        cell.textLabel?.backgroundColor = UIColor.black
        // Configure the cell...
        // -- edits for UI
        
        cell.textLabel?.layer.borderWidth = 3.0
        cell.textLabel?.layer.borderColor = UIColor.white.cgColor
        
        cell.textLabel?.layer.cornerRadius = 17.5
        cell.textLabel?.clipsToBounds = true
        cell.textLabel?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        // --- edits for UI
        let cellVideoName = FileManager.default.displayName(atPath: videoPaths[indexPath.row])
        
        cell.textLabel?.text = cellVideoName
        */
        
        //cell.configureCell(videoFilePath: videoPaths[indexPath.row])
        //
        let videoCellPath = videoPaths[indexPath.row]
        let videoCellTitle = FileManager.default.displayName(atPath: videoCellPath)
        let videoPreviewImage = videoAssetImages[indexPath.row]
        
        cell.titleLabel.text = videoCellTitle
        cell.imageVIew.image = videoPreviewImage
        //
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let deletedVideosPath = videoPaths[indexPath.row]
            if let _ = try? FileManager.default.removeItem(atPath: deletedVideosPath){
                videoPaths.remove(at: indexPath.row)
                videoAssetImages.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    //
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backToListViewSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissToListView" {
            if let sourceVC = segue.source as? ViewController {
                sourceVC.pauseVideo()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FileListToPlayerSegue" {
            if let destinationVC = segue.destination as? ViewController {
                let index = tableView.indexPathForSelectedRow!.row
                destinationVC.selectedVideoPath = videoPaths[index]
            }
        }
    }

}
