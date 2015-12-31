//
//  CatererItem.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CatererItem: NSObject {
    
    var name: String!
    var address: String!
    var contact: String!
    var catererID: String!
    var pffImage: PFFile!
    
    
    init(name: String, address: String, contact: String, catererID: String, pffImage: PFFile) {
        self.name = name
        self.address = address
        self.contact = contact
        self.catererID = catererID
        self.pffImage = pffImage
    }
}