//
//  CatererTableViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

class CatererTableViewController:  UITableViewController {
    
    
    private var catererItems: [CatererItem] = []
    private var catererImages = [PFFile: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveMenu()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catererItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CatererItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("CatererItemTableViewCell") as! CatererItemTableViewCell
        let item = catererItems[indexPath.row]
        
        //Update all the Non Image Dependent Values
        cell.catererNameLabel?.text = item.name        
        
        if !self.catererImages.isEmpty{
            let image = catererImages[item.pffImage]
            cell.catererImageView?.image =  image
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveMenu(){
        
        //create NSQueue
        let queue = NSOperationQueue()
        let queue2 = NSOperationQueue()
        
        //create a new PFQuery
        let query:PFQuery = PFQuery(className: "Caterer")
        
        // Get Menu Items from PARSE in the background (Thread Branch)
        queue.addOperationWithBlock() {
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    //loop through the objects array
                    for catererItem in objects!{
                        //Retrieve the values from the PFObject
                        let catererName:String? = (catererItem as PFObject)["name"] as? String
                        let catererAddress:String? = (catererItem as PFObject)["address"] as? String
                        let catererContact:String? = (catererItem as PFObject)["contact"] as? String
                        let catererID:String? = (catererItem as PFObject)["catererid"] as? String
                        let PFFImage:PFFile? = (catererItem as PFObject)["image"] as? PFFile
                        
                        //Append to Menu List
                        let loadedCatererItem = CatererItem(name: catererName!, address: catererAddress!, contact: catererContact!, catererID: catererID!, pffImage: PFFImage!)
                        self.catererItems.append(loadedCatererItem)
                    }
                    //When Downloading is Finished (Thread Join)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        //Load Images in the BackGround
                        queue2.addOperationWithBlock() {
                            for catererItem in self.catererItems{
                                catererItem.pffImage?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                    if error == nil{
                                        let catererItemImage = UIImage(data: imageData!)
                                        self.catererImages[catererItem.pffImage] = catererItemImage!
                                    }else {
                                        print("Error: \(error!) \(error!.userInfo)")
                                    }
                                })
                            }
                            NSOperationQueue.mainQueue().addOperationWithBlock() {
                                // when done, update your UI and/or model on the main queue IMAGE
                                self.tableView.reloadData()
                            }
                        }
                        // when done, update your UI and/or model on the main queue NON-IMAGE
                        self.tableView.reloadData()
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }

    
}
