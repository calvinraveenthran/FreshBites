//
//  MenuItemsManager.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

class MenuItemsManager: NSObject {
    
    static let sharedManager = MenuItemsManager()
    var resultItems = [MenuItem]()
    
    private override init() {}
 /*
    func retrieveMenu(){
            //create a new PFQuery
            let group = dispatch_group_create()
            dispatch_group_enter(group)
        
            var query:PFQuery = PFQuery(className: "MenuItem")
            query.whereKey("catererID", equalTo:"1")
            //call find objects in background
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil{
                    //loop through the objects array
                    for foodItem in objects!{
                        //Retrieve the values from the PFObject
                        let foodItemName:String? = (foodItem as PFObject)["name"] as? String
                        let foodItemIngredients:String? = (foodItem as PFObject)["ingredients"] as? String
                        let foodItemPrice:String? = (foodItem as PFObject)["price"] as? String
                        let PFFImage:PFFile? = (foodItem as PFObject)["image"] as! PFFile
                    
                    
                        PFFImage?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                            if error == nil{
                                let foodItemImage = UIImage(data: imageData!)
                                //assign it to our menuItem
                                if(foodItemName != nil){
                                    let loadedMenuItem = MenuItem(name: foodItemName!, ingredients: foodItemIngredients!, image: foodItemImage!, price: foodItemPrice!)
                                    self.resultItems.append(loadedMenuItem)
                                }
                            }else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        })
                    }
                dispatch_group_leave(group)
                }else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                dispatch_group_leave(group)
                }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            //println(self.itemArray?.count)
            //self.reloadData()
        }
    }*/

}
