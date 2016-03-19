//
//  CheckoutTableViewCell.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-24.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit

class CheckoutTableViewCell: UITableViewCell {
         var buttonDelegate: CheckoutTableViewCellDelegate?

    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var checkoutTableCellView: UIView!

    @IBOutlet weak var foodItemName: UILabel!
    @IBOutlet weak var foodItemComments: UILabel!
    @IBAction func addValuesButton(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(self, action: 0)
        }
       
    }
    @IBAction func removeValuesButton(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(self, action: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}







