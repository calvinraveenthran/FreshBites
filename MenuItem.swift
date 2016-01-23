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
    var objectID: String!
    var menuItemDescription: String!
    var priceInt: Int!
    
    init(name: String, ingredients: String, pffImage: PFFile, price: String, objectID: String, menuItemDescription: String, priceInt: Int) {
        self.name = name
        self.ingredients = ingredients
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

    var objectID: String!
    var quantity: Int!
    var comments: String!
    var price: Int!
    
    init(objectID: String, quantity: Int, comments: String, price: Int) {

        self.objectID = objectID
        self.quantity = quantity
        self.comments = comments
        self.price = price
    }

}