//
//  MenuViewController.swift
//  test
//
//  Created by Calvin Raveenthran on 2015-12-25.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

class MenuTableViewController:  UITableViewController {
    @IBOutlet weak var menu: UIBarButtonItem!
    
    private var menuItems: [MenuItem] = []
    private var menuImages = [PFFile: UIImage]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.midnightBlueColor()

        
        // Setting Up Side Navigation
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        //Retrieve Menu
        self.retrieveMenu()
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MenuItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuItemTableViewCell") as! MenuItemTableViewCell
        let item = menuItems[indexPath.row]

        //Update all the Non Image Dependent Values
        cell.menuItemNameLabel?.text = item.name
        cell.ingredientsItemLabel?.text = item.ingredients
        cell.priceItemLabel?.text = item.price
        
        //Update Image Values
        if !self.menuImages.isEmpty{
            let image = menuImages[item.pffImage]
            cell.menuItemImageView?.image =  image
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
        let query:PFQuery = PFQuery(className: "MenuItem")
        //query.whereKey("catererID", equalTo:"1")
        
        // Get Menu Items from PARSE in the background (Thread Branch)
        queue.addOperationWithBlock() {
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    //loop through the objects array
                    for foodItem in objects!{
                        //Retrieve the values from the PFObject
                        let foodItemName:String? = (foodItem as PFObject)["name"] as? String
                        let foodItemIngredients:String? = (foodItem as PFObject)["ingredients"] as? String
                        let foodItemPrice:String? = (foodItem as PFObject)["price"] as? String
                        let PFFImage:PFFile? = (foodItem as PFObject)["image"] as? PFFile
                        
                        //Append to Menu List
                        let loadedMenuItem = MenuItem(name: foodItemName!, ingredients: foodItemIngredients!, pffImage: PFFImage!, price: foodItemPrice!)
                        self.menuItems.append(loadedMenuItem)
                    }
                    //When Downloading is Finished (Thread Join)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        //Load Images in the BackGround
                        queue2.addOperationWithBlock() {
                            for foodItem in self.menuItems{
                                foodItem.pffImage?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                    if error == nil{
                                        let foodItemImage = UIImage(data: imageData!)
                                        self.menuImages[foodItem.pffImage] = foodItemImage!
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

