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


class ConversationsTableViewController:  UITableViewController{
    @IBOutlet weak var menu: UIBarButtonItem!
    private var conversationItems: [Conversations] = []

    override func viewDidLoad() {
    
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
        self.LoadConversationHead()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ConversationsTableViewCell = tableView.dequeueReusableCellWithIdentifier("ConversationsTableViewCell") as! ConversationsTableViewCell
        let item = conversationItems[indexPath.row]
        
        //1.    Update all the Non Image Dependent Values
        cell.catererNameLabel.text = item.catererName
        cell.newMesageImage.hidden = !item.newMessage
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMessageView" {
            
            let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
            let target = self.conversationItems[indexPath.row]
            
            
            let messageViewController = segue.destinationViewController as! MessageViewController
            messageViewController.conversationId = target.conversationId
        }
    }
    
    func LoadConversationHead(){
        
        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "Conversations")
        query.whereKey("customerId", equalTo:(PFUser.currentUser()?.objectId)!)
        
        
        //3.    Get conversations from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for conversationProperty in objects!{
                        let caterer:String? = (conversationProperty as PFObject)["caterer"] as? String
                        let cId:String? = conversationProperty.objectId
                        let message:Bool? = (conversationProperty as PFObject)["newMessage"] as? Bool
                        
                        let loadedMenuItem = Conversations(catererName: caterer!,  conversationId: cId!, newMessage: message!)
                        self.conversationItems.append(loadedMenuItem)
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