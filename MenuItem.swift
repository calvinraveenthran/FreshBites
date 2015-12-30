//
//  MenuItem.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MenuItem: NSObject {
    
    var name: String!
    var ingredients: String!
    var pffImage: PFFile!
    var price: String!
    
    init(name: String, ingredients: String, pffImage: PFFile, price: String) {
        self.name = name
        self.ingredients = ingredients
        self.pffImage = pffImage
        self.price = price
    }
    
    
}