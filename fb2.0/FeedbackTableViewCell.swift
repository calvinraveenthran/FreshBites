//
//  FeedbackTableViewCell.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-23.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit


class FeedbackTableViewCell: UITableViewCell {

    
    @IBOutlet weak var feedbackNameLabel: UILabel!
    
    @IBOutlet weak var feedbackTextLabel: UITextView!
    
    @IBOutlet weak var oneStarImgView: UIImageView!
    @IBOutlet weak var twoStarImgView: UIImageView!
    @IBOutlet weak var threeStarImgView: UIImageView!
    @IBOutlet weak var fourStarImgView: UIImageView!
    @IBOutlet weak var fiveStarImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }*/
    
    // MARK: - Public Methods
    func updateViewForRating(rating: Int) {
        let arrayOfImages: [UIImageView?] = [oneStarImgView, twoStarImgView, threeStarImgView, fourStarImgView, fiveStarImgView]
        
        for var i = 0; i < rating; i++ {
            let imgView = arrayOfImages[i]!
            imgView.hidden = false
        }
        
        for var i = rating; i < arrayOfImages.count; i++ {
            let imgView = arrayOfImages[i]!
            imgView.hidden = true
        }
    }


}