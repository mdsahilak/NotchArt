//
//  SettingsTableViewController.swift
//  NotchArt
//
//  Created by Muhammed Sahil on 06/01/19.
//  Copyright © 2019 MDAK. All rights reserved.
//

import UIKit
import SafariServices

class SettingsTableViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
    let helpURL = URL(string: "http://helloworldmdak.vapor.cloud/yolo")!
    
    @IBOutlet weak var hideNotchButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let hideNotchVal = userDefaults.double(forKey: "Notch_Hide_Constraint")
        if hideNotchVal == 30.0 {
            hideNotchButton.isOn = true
        } else {
            hideNotchButton.isOn = false
        }
        
    }

    @IBAction func hideNotchButtonTapped(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.set(30.0, forKey: "Notch_Hide_Constraint")
        } else {
            userDefaults.set(0.0, forKey: "Notch_Hide_Constraint")
        }
    }
    
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open help url in safari view controller if help cell is tapped
        if indexPath == IndexPath(row: 0, section: 1) {
            let safariViewController = SFSafariViewController(url: helpURL)
            safariViewController.preferredControlTintColor = UIColor.red
            safariViewController.preferredBarTintColor = UIColor.black
            self.present(safariViewController, animated: true, completion: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
