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


    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var checkoutTableCellView: UIView!

    @IBOutlet weak var foodItemName: UILabel!
    @IBOutlet weak var foodItemComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}







