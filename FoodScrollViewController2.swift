//
//  FoodScrollViewController2.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-02.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI

class FoodScrollViewController2: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var scrollView: UIScrollView!

    private var pageImages = [String:UIImage]()
    private var pages: [MenuItemPicture] = []

override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.midnightBlueColor()
    
    // 1
    self.LoadImageViews()
    
}
    
    
    func LoadImageViews(){

        //create NSQueue
        let queue = NSOperationQueue()
        let queue2 = NSOperationQueue()
        
        
        //create a new PFQuery
        let query:PFQuery = PFQuery(className: "images")
        query.whereKey("menuItemObjectID", equalTo:"DUxAFvbi7j")
        
        
        // Get Menu Items from PARSE in the background (Thread Branch)
        queue.addOperationWithBlock() {
            query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil{
                    //loop through the objects array
                    for foodPicture in objects!{
                        //Retrieve the values from the PFObject
                        let PFFImage:PFFile? = (foodPicture as PFObject)["foodImages"] as? PFFile
                        //let objectId:String? = (foodPicture as PFObject)["objectId"] as? String
                        let objectId:String? = foodPicture.objectId
                    
                        //Append to PageImages Array
                        let loadedPicture = MenuItemPicture(pffImage: PFFImage!, objectID: objectId!)
                        self.pages.append(loadedPicture)
                    }
                    //When Downloading is Finished (Thread Join)
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        //Load Images in the BackGround
                        queue2.addOperationWithBlock() {
                            for foodPicture in self.pages{
                                foodPicture.pffImage?.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                    if error == nil{
                                        let foodItemImage = UIImage(data: imageData!)
                                        self.pageImages[foodPicture.objectID] = foodItemImage!
                                        self.AddImageViews()
                                    }else {
                                        print("Error: \(error!) \(error!.userInfo)")
                                    }
                                })
                            }
                            NSOperationQueue.mainQueue().addOperationWithBlock() {
                                // when done, update your UI for the Scroll View
                            }
                        }
                        // when done, update your UI for Review and ETC.
                    }
                }else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }


    func AddImageViews(){
    
        let pageCount = pages.count
        
        for var index = 0; index < pageCount; ++index {
            
            let ImageView = UIImageView(frame: CGRectMake(self.scrollView.frame.width*CGFloat(index),-60, self.scrollView.frame.width, self.scrollView.frame.height))
            ImageView.image  = self.pageImages[pages[index].objectID] ;
            ImageView.contentMode = .ScaleAspectFit
            
            self.scrollView.addSubview(ImageView)
            
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*CGFloat(pageCount), 0)

    }
    
    func AddOtherViews() {}



}
