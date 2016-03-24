//
//  FoodScrollViewController2.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-02.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//
//  This File is to control the Menu Items Page Where student views
//


import Foundation
import UIKit
import CoreData
import Parse
import ParseUI

protocol FoodScrollViewController2Delegate{
    func appendToCheckout(childCheckoutObject:OrderItem)
}

class FoodScrollViewController2: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
        //Class Outlets
        @IBOutlet weak var itemsTable: UITableView!
        @IBOutlet weak var commentsTextField: UITextField!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var chefName: UILabel!
    
        var delegate : FoodScrollViewController2Delegate! = nil
    
    
        private var pageImages: [UIImage] = []
        private var itemList : NSMutableArray = []
    
    
        private var urlArrays: [PFFile] = []
        private var pictureCount: Int = 0
    
        //Variable of Controller Delegate (The Menu Item Selected in previous Table)
        var targetMenu: MenuItem!
        var chef: String!
        var itemCount: Int = 0
    
    
    
        @IBAction func AddToCart(sender: AnyObject) {
            if itemCount>0{
                let name:String = self.targetMenu.name
                let objectID:String = self.targetMenu.objectID
                let quantity:Int = self.itemCount
                let price:NSDecimalNumber = NSDecimalNumber(string: self.targetMenu.price)
                let comments:String = (self.commentsTextField.text)!
                let owner:String = self.targetMenu.owner
            
                let loadedOrder = OrderItem(name: name, objectID: objectID, quantity: quantity, comments:comments, price:price, owner:owner)
            
                let alert = UIAlertController(title: "Success", message: "Item Added", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                delegate.appendToCheckout(loadedOrder)
                
                self.commentsTextField.text = ""
                self.itemCount = 0;
                self.countLabel.text = "\(itemCount)"
            }
        }
    
        @IBAction func RemoveFromCount(sender: AnyObject) {
            if itemCount>0{
                itemCount--
                self.countLabel.text = "\(itemCount)"
            }
        }
    
        @IBAction func AddToCount(sender: AnyObject) {
            if itemCount<10{
                itemCount++
                self.countLabel.text = "\(itemCount)"
            }
        }
    
    


override func viewDidLoad() {
        super.viewDidLoad()
    
        self.itemsTable.dataSource = self
        self.itemsTable.delegate = self
        //1. Set BcckGround Color
        //self.view.backgroundColor = UIColor.midnightBlueColor()
    
        //2. Call method to load the View
        self.LoadImageViews()
        self.LoadItemTableArray()
    
        //self.itemDescriptionDescriptionTextView.text = targetMenu.menuItemDescription
    
        self.countLabel.text = "\(itemCount)"
        self.chefName.text = "Chef: " + self.chef
        self.commentsTextField.delegate = self;
    
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
}
    
func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
}
    
    
func LoadImageViews(){

        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        let queue2 = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "Menu")
        query.whereKey("objectId", equalTo:targetMenu.objectID)
        
        
        //3.    Get Menu Items from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for foodPicture in objects!{
                        
                        self.urlArrays = (foodPicture as PFObject)["menuPhotos"] as! [PFFile]
                        self.pictureCount = self.urlArrays.count
                    }
                    
                    //4.    When Downloading is Finished (Join queue)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                            for foodPicture in self.urlArrays{
                                
                                //5.    Now go and get the actual image with PFFIMage Key.(Fork queue 2)
                                queue2.addOperationWithBlock() {
                                    foodPicture.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                        if error == nil{
                                            let foodItemImage = UIImage(data: imageData!)
                                            self.pageImages.append(foodItemImage!)
                                        } else {
                                            print("Error: \(error!) \(error!.userInfo)")
                                        }
                                        
                                        NSOperationQueue.mainQueue().addOperationWithBlock() {
                                            // when done, update your UI for the Scroll View
                                            if self.pageImages.count == self.pictureCount{
                                                self.AddImageViews()
                                            }
                                        }
                                    })
                                }
                            }

                        // when done, update your UI for Review and ETC.
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            })
        }
    }

    // Create SubView for Scrollview of ImageViews and add them to ScrollView
    func AddImageViews(){
    
        let pageCount = self.pictureCount
        
        for var index = 0; index < pageCount; ++index {
            
            let ImageView = UIImageView(frame: CGRectMake(self.scrollView.frame.width*CGFloat(index),0, self.scrollView.frame.width, self.scrollView.frame.height))
            ImageView.image  = self.pageImages[index]
            ImageView.contentMode = .ScaleAspectFit
            
            self.scrollView.addSubview(ImageView)
            
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*CGFloat(pageCount), 0)

    }

    func LoadItemTableArray(){
        
        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "Menu")
        query.whereKey("objectId", equalTo:targetMenu.objectID)
        
        
        //3.    Get Menu Items from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for foodPicture in objects!{
                        self.itemList = ((foodPicture as PFObject)["items"])! as! NSMutableArray
                    }
                    
                    //4.    When Downloading is Finished (Join queue)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        self.itemsTable.reloadData()
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            })
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= (keyboardSize.height - 53)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += (keyboardSize.height - 53)
         }
    }
    
    /*override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }*/


}



// MARK: - UITableViewDataSource
extension FoodScrollViewController2: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tableCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        

        cell.textLabel?.text = (self.itemList[indexPath.row]["itemName"] as! String) + "  " + "(" + "\(self.itemList[indexPath.row]["servings"] as! Int)" + " servings)"
        
        return cell
    }
    

}



extension FoodScrollViewController2: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let itemName = self.itemList[indexPath.row]["itemName"] as! String
        let itemDescription = self.itemList[indexPath.row]["itemDescription"] as! String
        
        
        let alert = UIAlertView(title: itemName, message: itemDescription, delegate: self, cancelButtonTitle: "OK")
        alert.show()
        
    }

}



