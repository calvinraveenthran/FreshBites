//
//  MenuItemTableViewCell.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var menuItemNameLabel: UILabel!
    
    @IBOutlet weak var ingredientsItemLabel: UILabel!
    
    @IBOutlet weak var priceItemLabel: UILabel!
    
    @IBOutlet weak var menuItemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
