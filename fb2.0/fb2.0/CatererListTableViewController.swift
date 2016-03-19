//
//  CatererListTableViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-02-19.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI


protocol CatererListTableViewControllerDelegate{
    func appendToConversations(childObject:String)
}

class CatererListTableViewController:  UITableViewController{
    var caterers : [String] = []
    
    var delegate : CatererListTableViewControllerDelegate! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.loadCaterers()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caterers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CaterersTableViewCell = tableView.dequeueReusableCellWithIdentifier("catererName") as! CaterersTableViewCell
        let item = caterers[indexPath.row]
        
        //1.    Update all the Non Image Dependent Values
        cell.catererNameLabel?.text = item
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.appendToConversations(caterers[indexPath.row])
    }
    
    
    func loadCaterers(){
        
        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "_User")
        query.orderByAscending("User")
        query.whereKey("userRole", equalTo:"caterer")
        
        
        //3.    Get conversations from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for catererName in objects!{
                        let name:String? = (catererName as PFObject)["username"] as? String
                        self.caterers.append(name!)
                    }
                    
                    //4.    When Downloading is Finished (Join queue)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        self.tableView.reloadData()
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            })
        }
    }
    
}

