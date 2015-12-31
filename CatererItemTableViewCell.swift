//
//  CatererItemTableViewCell.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation


import UIKit

class CatererItemTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var catererNameLabel: UILabel!
    @IBOutlet weak var catererImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}