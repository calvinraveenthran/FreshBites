//
//  BackViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-31.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import CoreData
import Parse
import ParseUI

class BackViewController: UIViewController {

    
    @IBOutlet weak var backTableView: UITableView!
    var  backTableArray = ["Menu", "Checkout", "Messages", "Profile", "Order History", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.midnightBlueColor()
        //self.backTableView.backgroundColor = UIColor.midnightBlueColor()
        self.backTableView.dataSource = self
        self.backTableView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
    
    
// MARK: - UITableViewDataSource
extension BackViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return backTableArray.count
        }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(backTableArray[indexPath.row], forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = backTableArray[indexPath.row]
        //cell.backgroundColor = UIColor.midnightBlueColor()
        
        return cell
    }
}

extension BackViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 5{
            UserSessionManager.userSharedManager.checkoutArray.removeAll()
            PFUser.logOut()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.backTableView.reloadData()
        }
    }
}
