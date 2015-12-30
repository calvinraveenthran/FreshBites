//
//  CatererItem.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit

class CatererItem: NSObject {
    
    var name: String!
    var address: String!
    var contact: String!
    var catererID: String!
    var menuItem: [MenuItem]!
    
    
    init(name: String, address: String, contact: String, catererID: String) {
        self.name = name
        self.address = address
        self.contact = contact
        self.catererID = catererID
    }
}