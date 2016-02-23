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
    var pffImage: PFFile!
    var price: String!
    var objectID: String!
    var menuItemDescription: String!
    var priceInt: Int!
    
    init(name: String,  menuItemDescription: String, pffImage: PFFile, price: String, objectID: String, priceInt: Int) {
        self.name = name
        self.pffImage = pffImage
        self.price = price
        self.objectID = objectID
        self.menuItemDescription = menuItemDescription
        self.priceInt = priceInt
    }
    
    
}

class MenuItemPicture: NSObject {
    
    var pffImage: PFFile!
    var objectID: String!
    
    init(pffImage: PFFile, objectID: String) {
        self.pffImage = pffImage
        self.objectID = objectID
    }
}

class OrderItem: NSObject{
    var name: String!
    var objectID: String!
    var quantity: Int!
    var comments: String!
    var price: Int!
    
    init(name: String, objectID: String, quantity: Int, comments: String, price: Int) {

        self.name = name
        self.objectID = objectID
        self.quantity = quantity
        self.comments = comments
        self.price = price
    }

}