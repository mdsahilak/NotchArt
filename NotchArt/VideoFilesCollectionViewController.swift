//
//  VideoFilesCollectionViewController.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 25/12/18.
//  Copyright © 2018 MDAK. All rights reserved.
//

import UIKit
import AVFoundation

class VideoFilesCollectionViewController: UICollectionViewController {
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    var notchArtFiles: [NotchArtFile] = []
    var videoPaths: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
        
        loadVideosFromDocumentsDir()
        //navigationController?.toolbar.isHidden = true
        changeShareAndTrashButtonEnabled(to: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func refresh() {
        
        let documentsDirChanged = documentDirDidChange()
        
        if documentsDirChanged == true {
            videoPaths.removeAll()
            notchArtFiles.removeAll()
            loadVideosFromDocumentsDir()
            collectionView.reloadData()
        }
        self.collectionView.refreshControl?.endRefreshing()
        
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
    
    var isInEditMode: Bool = false {
        didSet{
            if isInEditMode {
                //collectionView.allowsMultipleSelection = true
                collectionView.refreshControl?.isEnabled = false
                changeShareAndTrashButtonEnabled(to: true)
            } else {
                //collectionView.allowsMultipleSelection = false
                collectionView.refreshControl?.isEnabled = true
                changeShareAndTrashButtonEnabled(to: false)
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        if isInEditMode {
            sender.title = "Done"
        }else {
            sender.title = "Edit"
        }
        unColorItems()
    }
    
    
    @IBAction func didTapTrashButton(_ sender: UIBarButtonItem) {
        guard let selections = collectionView.indexPathsForSelectedItems else {return}
            let descendingOrderSelections = selections.sorted { $0 > $1 }
            // descendingOrder array was made to prevent index out of range errors
            // collectionView deletions should take place in descending order only
            // a shorthand sort{} closure is used to make the new array.
        
            collectionView.performBatchUpdates({
                for selection in descendingOrderSelections {
                    do {
                        try FileManager.default.removeItem(at: notchArtFiles[selection.item].url)
                        collectionView.deleteItems(at: [selection])
                        notchArtFiles.remove(at: selection.item)
                        videoPaths.remove(at: selection.item)
                    } catch {
                        // in case of inabilty to delete, handle it here
                        print("Error at didTapTrashButton IBaction Func in VideoFilesCollectionViewController.swfit")
                    }
                }
                
            }, completion: nil)
            
    }
    
    @IBAction func didTapActionButton(_ sender: UIBarButtonItem) {
        guard let selectedItemsPaths = collectionView.indexPathsForSelectedItems else {return}
        let selectedVideosInt = selectedItemsPaths.compactMap({ (indexPath) -> Int in
            return indexPath.item
        })
        var selectedNotchFiles: [Any] = []
        for int in selectedVideosInt {
            selectedNotchFiles.append(notchArtFiles[int].url)
        }
        
        let activityController = UIActivityViewController(activityItems: selectedNotchFiles, applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return notchArtFiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoFileCell", for: indexPath) as? VideoFileCollectionViewCell else {return UICollectionViewCell()}
        let currentNotchArtFile = notchArtFiles[indexPath.row]
        // Configure the cell
        cell.imageView.image = currentNotchArtFile.previewImage
        cell.titleLabel.text = currentNotchArtFile.title
        
        if cell.isSelected {
            cell.backgroundColor = UIColor.darkGray
        } else {
            cell.backgroundColor = UIColor.clear
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isInEditMode else {return}
        
        let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderColor = UIColor.red.cgColor
        cell?.backgroundColor = UIColor.darkGray
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard isInEditMode else {return}
        let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.backgroundColor = UIColor.clear
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isInEditMode {
            return false
        }else {
            return true
        }
    }
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    @IBAction func backToVideosListSegue(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? ViewController {
            sourceVC.pauseVideo()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CVtoPlayer" {
            let index = collectionView.indexPathsForSelectedItems!.first
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.selectedNotchArtFile = notchArtFiles[index!.item]
                destinationVC.selectedFileIndexPath = collectionView.indexPathsForSelectedItems?.first
                destinationVC.notchArtFiles = self.notchArtFiles
            }
            collectionView.deselectItem(at: index!, animated: false)
            
        }
    }
    
    // Start-Excess Methods
    
    func changeShareAndTrashButtonEnabled(to state: Bool) {
        if let toolbarItems = toolbarItems {
            let shareItem = toolbarItems[0]
            let trashItem = toolbarItems[4]
            //Disable these
            shareItem.isEnabled = state
            trashItem.isEnabled = state
        }
    }
    
    func unColorItems() {
        
        collectionView.performBatchUpdates({
            var index = 0
            for i in 0...notchArtFiles.count{
                let indexPath = IndexPath(item: index, section: 0)
                collectionView.deselectItem(at: indexPath, animated: true)
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor.clear
                
                index += 1
            }
            index = 0
        }, completion: nil)
        
    }
    
    // End-Excess Methods
    

}



extension VideoFilesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        if view.frame.width / view.frame.height > 1 {
            //LandscapeLeft or LandscapeRight
            return CGSize(width: widthPerItem, height: view.frame.height / 2)
        } else {
            //Portrait or UpsideDown
            let width = view.frame.width - 14
            let height = (1 * width) / 1.5
            return CGSize(width: width , height: height )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if view.frame.width / view.frame.height > 1 {
            //LandscapeLeft or LandscapeRight
            return UIEdgeInsets(top: 7.0, left: 30.0, bottom: 0.0, right: 30)
        } else {
            //Portrait or UpsideDown
            return UIEdgeInsets(top: 7, left: 7, bottom: 0, right: 7)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
 
}
