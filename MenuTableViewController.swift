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

class MenuTableViewController:  UITableViewController, OrderItemTabBarControllerDelegate {
    
    //  Class Variables
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var usernameButton: UIBarButtonItem!

    // menuImages is a mapping of the image with the picture id
    // menuItems is an object of a Menu.
    private var menuItems: [MenuItem] = []
    private var menuImages = [PFFile: UIImage]()    
    var checkoutArray: [OrderItem] = UserSessionManager.userSharedManager.checkoutArray
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.    Set Background Color
        self.tableView.backgroundColor = UIColor.midnightBlueColor()
        
        //2.    Setting Up Side Navigation
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        //3.    Retrieve Menu
        self.retrieveMenu()
        
        //4.    UsernameButton title;
        usernameButton.title = PFUser.currentUser()!.username

        

        
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MenuItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuItemTableViewCell") as! MenuItemTableViewCell
        let item = menuItems[indexPath.row]

        //1.    Update all the Non Image Dependent Values
        cell.menuItemNameLabel?.text = item.name
        cell.ingredientsItemLabel?.text = item.menuItemDescription
        cell.priceItemLabel?.text = item.price
        
        //3.    Update Image Values
        if !self.menuImages.isEmpty{
            let image = menuImages[item.pffImage]
            cell.menuItemImageView?.image =  image
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
  /*  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        let targetMenu = menuItems[indexPath.row]

        performSegueWithIdentifier("showTargetMenu", sender: targetMenu)
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTargetMenu" {
            
            let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
            let targetMenu = self.menuItems[indexPath.row]
            
            
            let tabBarController = segue.destinationViewController as! OrderItemTabBarController
                tabBarController.myDelegate = self
            
            let desView: FoodScrollViewController2 = tabBarController.viewControllers?.first as! FoodScrollViewController2
                desView.targetMenu = targetMenu
                desView.delegate = tabBarController
            let desView2: FeedbackViewController = tabBarController.viewControllers?.last as! FeedbackViewController
                desView2.targetMenu = targetMenu
        }
    }
    
    func appendToCheckoutMaster(childCheckoutObject:OrderItem) {
        UserSessionManager.userSharedManager.checkoutArray.append(childCheckoutObject)
        checkoutArray = UserSessionManager.userSharedManager.checkoutArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveMenu(){
        
        //1.    create NSQueue
        let queue = NSOperationQueue()
        let queue2 = NSOperationQueue()
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "MenuItem")
        
        //3.    Get Menu Items from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for foodItem in objects!{

                        let foodItemName:String? = (foodItem as PFObject)["name"] as? String
                        let foodItemDescription:String? = (foodItem as PFObject)["description"] as? String
                        let foodItemPrice:String? = (foodItem as PFObject)["price"] as? String
                        let PFFImage:PFFile? = (foodItem as PFObject)["image"] as? PFFile
                        let foodItemObjectId:String? = foodItem.objectId
                        let foodItemPriceInt:Int? = (foodItem as PFObject)["priceInt"] as? Int
                        
                        //Append to Menu List
                        let loadedMenuItem = MenuItem(name:foodItemName!, menuItemDescription:foodItemDescription!,pffImage:PFFImage!,price:foodItemPrice!, objectID:foodItemObjectId!, priceInt:foodItemPriceInt!)
                        self.menuItems.append(loadedMenuItem)
                    }
                    
                    //4.    When Downloading is Finished (Join queue)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        //5.    Now go and get the actual image with PFFIMage Key.(Fork queue 2)
                        for foodItem in self.menuItems{
                            queue2.addOperationWithBlock() {
                                foodItem.pffImage?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                    if error == nil{
                                        let foodItemImage = UIImage(data: imageData!)
                                        self.menuImages[foodItem.pffImage] = foodItemImage!
                                    }else {
                                        print("Error: \(error!) \(error!.userInfo)")
                                    }
                                })
                            
                                NSOperationQueue.mainQueue().addOperationWithBlock() {
                                    if self.menuImages.count == self.menuItems.count {
                                        self.tableView.reloadData()
                                    }
                                }
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

