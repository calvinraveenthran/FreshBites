//
//  MessagesTableViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-02-16.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI


class MessageTableViewController:  UITableViewController{
    private var messages: [Message] = []
    var conversationId: String = ""
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        self.LoadMessages()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell") as! MessageTableViewCell
        let item = messages[indexPath.row]
        
        //1.    Update all the Non Image Dependent Values
        if item.sender == PFUser.currentUser()?.username{
            cell.myNameLabel.text = PFUser.currentUser()?.username
            cell.catererNameLabel.text = ""
            cell.messageLabel.text = item.message
        }else{
            cell.catererNameLabel.text = item.sender
            cell.myNameLabel.text = ""
            cell.messageLabel.text = item.message
            cell.messageLabel.textAlignment = NSTextAlignment.Right;
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func LoadMessages(){
        
        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "Messages")
        query.orderByAscending("updatedAt")
        query.whereKey("messageId", equalTo:(self.conversationId))
        
        
        //3.    Get conversations from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for conversationProperty in objects!{
                        let sender:String? = (conversationProperty as PFObject)["sender"] as? String
                        let receiver:String? = (conversationProperty as PFObject)["receiver"] as? String
                        let message:String? = (conversationProperty as PFObject)["content"] as? String
                        
                        let loadedMenuItem = Message(sender: sender!, receiver: receiver!, conversationId: self.conversationId, message: message!)
                        self.messages.append(loadedMenuItem)
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