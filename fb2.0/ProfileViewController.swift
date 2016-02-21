//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    private var profileProperties: [String] = []


    override func viewDidLoad() {
       
        
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
        self.phoneNumberTextField.delegate = self;
        self.postalCodeTextField.delegate = self;
        self.cityTextField.delegate = self;
        self.addressTextField.delegate = self;
        self.loadCurrentValues()
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func loadCurrentValues(){
        //1.    create NSQueue's
        //      one for the inital pull from parse
        //      second to process each image in the back ground
        let queue = NSOperationQueue()
        
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo:(PFUser.currentUser()?.objectId)!)
        
        
        //3.    Get conversations from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for profileProperty in objects!{
                        let address:String? = (profileProperty as PFObject)["address"] as? String
                        let city:String? = (profileProperty as PFObject)["city"] as? String
                        let postalCode:String? = (profileProperty as PFObject)["postalCode"] as? String
                        let phone:String? = (profileProperty as PFObject)["phone"] as? String
                        
                        self.profileProperties.append(address!)
                        self.profileProperties.append(city!)
                        self.profileProperties.append(postalCode!)
                        self.profileProperties.append(phone!)
                    }
                    
                    //4.    When Downloading is Finished (Join queue)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        self.addressTextField.text = self.profileProperties[0]
                        self.cityTextField.text = self.profileProperties[1]
                        self.postalCodeTextField.text = self.profileProperties[2]
                        self.phoneNumberTextField.text = self.profileProperties[3]
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            })
        }
    
    
    }
    
    
    @IBAction func updateButton(sender: AnyObject) {
        
        if self.addressTextField.text != self.profileProperties[0] || self.cityTextField.text != self.profileProperties[1] || self.postalCodeTextField.text != self.profileProperties[2] || self.phoneNumberTextField.text != self.profileProperties[3] {
            
            self.profileProperties[0] = self.addressTextField.text!
            self.profileProperties[1] = self.cityTextField.text!
            self.profileProperties[2] = self.postalCodeTextField.text!
            self.profileProperties[3] = self.phoneNumberTextField.text!
            
            var query = PFQuery(className:"_User")
            query.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId)!) {
                (userProfile: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let userProfile = userProfile {
                    userProfile["address"] = self.profileProperties[0]
                    userProfile["city"] = self.profileProperties[1]
                    userProfile["postalCode"] = self.profileProperties[2]
                    userProfile["phone"] = self.profileProperties[3]
                    userProfile.saveInBackground()
                }
            }
            
        }
        
        
        
    }
    
    
    
    
    
    

}