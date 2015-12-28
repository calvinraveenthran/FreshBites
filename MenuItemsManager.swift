//
//  MenuItemsManager.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit

class MenuItemsManager: NSObject {
    
    static let sharedManager = MenuItemsManager()
    
    private override init() {}
    
    // MARK: - Public Methods
    func loadData() -> [MenuItem] {
        let path = NSBundle.mainBundle().pathForResource("MenuItems", ofType: "plist")
        if let dataArray = NSArray(contentsOfFile: path!) {
            return constructMenuItemsFromArray(dataArray)
        } else {
            return [MenuItem]()
        }
    }
    
    // MARK: - Private Methods
    private func constructMenuItemsFromArray(array: NSArray) -> [MenuItem] {
        var resultItems = [MenuItem]()
        
        for object in array {
            let name = object["name"] as! String
            let ingredients = object["ingredients"] as! String
            let image = object["image"] as! String
            let price = object["price"] as! String
            let discount = object["discount"] as? String
            
            let loadedMenuItem = MenuItem(name: name, ingredients: ingredients, image: image, price: price, discount: discount)
            resultItems.append(loadedMenuItem)
        }
        return resultItems
    }
}
