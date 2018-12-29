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
    
    var notchArtFiles: [NotchArtFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideosFromDocumentsDir()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        let documentsDirChanged = documentDirDidChange()
        
        if documentsDirChanged == true {
            videoPaths.removeAll()
            notchArtFiles.removeAll()
            loadVideosFromDocumentsDir()
            tableView.reloadData()
        }
        self.tableView.refreshControl?.endRefreshing()
        
    }
    
    func loadVideosFromDocumentsDir() {
        let documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        print(documentsDirectoryPath)
        
        guard let DocumentDirectoryVideoNames = try? FileManager.default.subpathsOfDirectory(atPath: documentsDirectoryPath)
            else { return }
        
        for videoName in DocumentDirectoryVideoNames {
            let path = documentsDirectoryPath + "/" + videoName
            videoPaths.append(path)
            
            //
            let notchArtFile = NotchArtFile(url: URL(fileURLWithPath: path))
            notchArtFiles.append(notchArtFile)
            //
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
        return notchArtFiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoFileCellIdentifier", for: indexPath) as? videoTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text = notchArtFiles[indexPath.row].title
        cell.imageVIew.image = notchArtFiles[indexPath.row].previewImage
        
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
            let deletedVideosPath = notchArtFiles[indexPath.row]
            if let _ = try? FileManager.default.removeItem(atPath: deletedVideosPath.path){
                notchArtFiles.remove(at: indexPath.row)
                videoPaths.remove(at: indexPath.row)
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
        if let sourceVC = segue.source as? ViewController {
            sourceVC.pauseVideo()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FileListToPlayerSegue" {
            if let destinationVC = segue.destination as? ViewController {
                let index = tableView.indexPathForSelectedRow!.row
                destinationVC.selectedNotchArtFile = notchArtFiles[index]
                destinationVC.selectedFileIndexPath = tableView.indexPathForSelectedRow!
                destinationVC.notchArtFiles = self.notchArtFiles
            }
        }
    }

}
