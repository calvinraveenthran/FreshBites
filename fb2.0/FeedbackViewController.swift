//
//  FeedbackViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-23.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//  This is the view controller for the reviews page
//
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI

enum Rating: Int {
    case OneStar = 1
    case TwoStar
    case ThreeStar
    case FourStar
    case FiveStar
}


class FeedbackViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var feedbackTableView: UITableView!
    

    @IBOutlet weak var oneStarBtn: UIButton!
    @IBOutlet weak var twoStarBtn: UIButton!
    @IBOutlet weak var threeStarBtn: UIButton!
    @IBOutlet weak var fourStarBtn: UIButton!
    @IBOutlet weak var fiveStarBtn: UIButton!
    
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var feedbackField: UITextField!
    @IBOutlet weak var addFeedbackBtn: UIButton!
    
    private var feedbacks: [Feedback] = []
    private var currentFeedbackRating: Int = 0
    var targetMenu: MenuItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTableView.dataSource = self
        self.retrieveFeedback()
        
        self.nameField.delegate = self;
        self.feedbackField.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)


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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Private Methods
    private func changeRatingFor(newRating: Int) {
        currentFeedbackRating = newRating
        
        let starImage = UIImage(named: "star_chosen")
        let greyStarImage = UIImage(named: "star_unchosen")
        
        let arrayOfButtons: [UIButton?] = [oneStarBtn, twoStarBtn, threeStarBtn, fourStarBtn, fiveStarBtn]
        
        for var i = 0; i < newRating; i++ {
            if let btn = arrayOfButtons[i]! as UIButton! {
                btn.setImage(starImage, forState: .Normal)
            }
        }
        
        for var i = newRating; i < arrayOfButtons.count; i++ {
            if let btn = arrayOfButtons[i]! as UIButton! {
                btn.setImage(greyStarImage, forState: .Normal)
            }
        }
    }
    
    @IBAction func sendFeedback(sender: AnyObject) {
        let newFeedback = Feedback()
        var reviewSend = PFObject(className:"Feedback")
        
        if let name = nameField?.text {
            newFeedback.name = name
            reviewSend["name"] = name
        }
        
        if let text = feedbackField?.text {
            newFeedback.text = text
            reviewSend["opinion"] = text
        }
        
        newFeedback.numberOfStars = currentFeedbackRating
        reviewSend["numberOfStars"] = currentFeedbackRating
        
        reviewSend["menuItemObjectID"] = targetMenu.objectID
        reviewSend["catererId"] = targetMenu.owner
        
        
        //GET IN
        //Add to current array
        feedbacks.append(newFeedback)
        self.feedbackTableView.reloadData()
        
        //Also push to the backend
        reviewSend.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        
        nameField?.text = ""
        feedbackField?.text = ""
        nameField?.resignFirstResponder()
        feedbackField?.resignFirstResponder()
        
    }
    
    
    @IBAction func onOneStar(sender: AnyObject) {
        changeRatingFor(Rating.OneStar.rawValue)
    }
    
    @IBAction func onTwoStar(sender: AnyObject) {
        changeRatingFor(Rating.TwoStar.rawValue)
    }
    
    @IBAction func onThreeStar(sender: AnyObject) {
        changeRatingFor(Rating.ThreeStar.rawValue)
    }
    
    @IBAction func onFourStar(sender: AnyObject) {
        changeRatingFor(Rating.FourStar.rawValue)
    }
    
    @IBAction func onFiveStar(sender: AnyObject) {
        changeRatingFor(Rating.FiveStar.rawValue)
    }
    
    
    
    func retrieveFeedback(){
        
        //1.    create NSQueue
        let queue = NSOperationQueue()
        
        //2.    create a new PFQuery
        let query:PFQuery = PFQuery(className: "Feedback")
        query.whereKey("menuItemObjectID", equalTo:targetMenu.objectID)
        
        //3.    Get Menu Items from PARSE in the background (Fork queue)
        queue.addOperationWithBlock() {
            
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    //  loop through the objects array
                    //  Retrieve the values from the PFObject
                    for review in objects!{
                        
                        let reviewName:String? = (review as PFObject)["name"] as? String
                        let reviewOpinion:String? = (review as PFObject)["opinion"] as? String
                        let reviewRating:Int? = (review as PFObject)["numberOfStars"] as? Int
                        
                        //Append to Feedback array
                        let loadedReviewItem = Feedback(name: reviewName!, text: reviewOpinion!, numberOfStars: reviewRating!)
                        self.feedbacks.append(loadedReviewItem)
                    }
                    
                    //4.    When Downloading is Finished (Join queue)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                            self.feedbackTableView.reloadData()
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }
}



// MARK: - UITableViewDataSource
extension FeedbackViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FeedbackTableViewCell = tableView.dequeueReusableCellWithIdentifier("feedBackCell") as! FeedbackTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let feedback = feedbacks[indexPath.row]
        
        cell.feedbackNameLabel?.text = feedback.name
        cell.feedbackTextLabel?.text = feedback.text
        cell.updateViewForRating(feedback.numberOfStars)
        return cell
    }
}
