//
//  CatererItemsManager.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

class CatererItemsManager: NSObject {
    
    static let sharedManager = CatererItemsManager()
    var resultItems = [CatererItem]()
    
    private override init() {}
  /*
    func retrieveMenu() -> [CatererItem]{
        if self.resultItems.isEmpty {
            
            //create a new PFQuery
            var query:PFQuery = PFQuery(className: "Caterer")
            //call find objects in background
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    //loop through the objects array
                    for CatererItem in objects!{
                        //Retrieve the values from the PFObject
                        let catererItemName:String? = (CatererItem as PFObject)["name"] as? String
                        let catererItemID:String? = (CatererItem as PFObject)["catererID"] as? String
                        let catererItemContact:String? = (CatererItem as PFObject)["contact"] as? String
                        let catererItemAddress:String? = (CatererItem as PFObject)["address"] as? String
                        
                        /*let PFFImage:PFFile? = (foodItem as PFObject)["image"] as! PFFile
                        var foodItemImage: UIImage? = UIImage()
                        
                        
                        PFFImage?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                            if error == nil{
                                foodItemImage = UIImage(data: imageData!)
                            }else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        })*/
                        
                      /*  //assign it to our menuItem
                        if(catererItemName != nil){
                            let loadedCatererItem = CatererItem(name: catererItemName!, address: catererItemAddress!, image: foodItemImage!, price: foodItemPrice!)
                            
                            name: String, address: String, contact: String, catererID: String
                            self.resultItems.append(loadedMenuItem)
                        }
                    }
                }else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }*/
                
            }
        }
        
        return resultItems
    }*/
    
}
