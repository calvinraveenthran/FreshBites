//
//  MessageViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-02-18.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI


class MessageViewController:  UIViewController, UITextFieldDelegate {
    private var messages: [Message] = []
    var conversationId: String = ""
    var caterer: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var textView: UIView!
    @IBAction func sendMessageButton(sender: AnyObject) {
    
        let newMessage = Message(sender: "", conversationId: "", message: "", receiver: "")
        var messageSend = PFObject(className:"Messages")
        
        let content = self.messageTextField?.text
        
        if content != "" {
            newMessage.message = content
            messageSend["content"] = newMessage.message
            
            newMessage.sender = PFUser.currentUser()?.username
            messageSend["from"] = newMessage.sender
            
            newMessage.conversationId = self.conversationId
            messageSend["messageId"] = newMessage.conversationId
            
            newMessage.receiver = self.caterer
            messageSend["to"] = newMessage.receiver
            
            messageSend["read"] = false
        }
        
        //GET IN
        //Add to current array
        messages.append(newMessage)
        self.tableView.reloadData()
        
        //Also push to the backend
        messageSend.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        self.messageTextField?.text = ""
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.dataSource = self
        self.LoadMessages()
        self.messageTextField.delegate = self
        
        
        // Keyboard stuff.
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
        
        func keyboardWillShow(notification: NSNotification) {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= keyboardSize.height
            }
            
        }
        
        func keyboardWillHide(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
                        let sender:String? = (conversationProperty as PFObject)["from"] as? String
                        let message:String? = (conversationProperty as PFObject)["content"] as? String
                        let receiver:String? = (conversationProperty as PFObject)["to"] as? String
                        
                        let loadedMenuItem = Message(sender: sender!, conversationId: self.conversationId, message: message!, receiver: receiver!)
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

// MARK: - UITableViewDataSource
extension MessageViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
}