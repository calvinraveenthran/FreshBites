//
//  FeedbackViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-23.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
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


class FeedbackViewController: UIViewController{
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTableView.dataSource = self

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
        
        if let name = nameField?.text {
            newFeedback.name = name
        }
        
        if let text = feedbackField?.text {
            newFeedback.text = text
        }
        
        newFeedback.numberOfStars = currentFeedbackRating
        
        
        //GET IN
        feedbacks.append(newFeedback)
        self.feedbackTableView.reloadData()
        
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

// MARK: - UITableViewDelegate
/*extension FeedbackViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell: FeedbackTableViewCell = tableView.dequeueReusableCellWithIdentifier("feedBackCell") as! FeedbackTableViewCell
        
        let feedback = feedbacks[indexPath.row]
        
        cell.feedbackNameLabel?.text = feedback.name
        cell.feedbackTextLabel?.text = feedback.text
        
        let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        return height
    }
}*/
