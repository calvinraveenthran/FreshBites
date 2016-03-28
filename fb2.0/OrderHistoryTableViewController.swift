//
//  OrderHistoryTableViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-02-20.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI


class OrderHistoryTableViewController:  UITableViewController {
    @IBOutlet weak var menu: UIBarButtonItem!
    private var orderHistoryItems: [OrderHistory] = []
    
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
        self.LoadOrderHistory()
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: OrderHistoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        let item = orderHistoryItems[indexPath.row]
        
        //1.    Update all the Non Image Dependent Values
        cell.foodNameLabel.text = item.name
        cell.foodPriceLabel.text = "$\(item.quantity*item.price)"
        cell.purchaseDateLabel.text = item.date
        cell.purchaseDateLabel.textColor = UIColor.concreteColor()
        if item.fulfilled == true {
            cell.foodStatusLabel.text = "Fulfilled"
            cell.foodStatusLabel.textColor = UIColor.greenSeaColor()
        }else{
            cell.foodStatusLabel.text = "Pending"
            cell.foodStatusLabel.textColor = UIColor.sunflowerColor()
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    
    func LoadOrderHistory(){
        
        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "Orders")
         query.orderByAscending("updatedAt")
        query.whereKey("customer", equalTo:(PFUser.currentUser()?.username)!)
        
        
        //3.    Get conversations from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for orderProperty in objects!{
                        let foodName:String? = (orderProperty as PFObject)["foodName"] as? String
                        let foodPrice:Int? = (orderProperty as PFObject)["price"] as? Int
                        let foodQuantity:Int? = (orderProperty as PFObject)["quantity"] as? Int
                        let foodFulfilled:Bool? = (orderProperty as PFObject)["fulfilled"] as? Bool
                        let dateUpdated = orderProperty.updatedAt! as NSDate
                        
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        
                        let loadedOrderItem = OrderHistory(name: foodName!, quantity: foodPrice!, price: foodQuantity! , date: dateFormatter.stringFromDate(dateUpdated), fulfilled: foodFulfilled!)
                        self.orderHistoryItems.append(loadedOrderItem)
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