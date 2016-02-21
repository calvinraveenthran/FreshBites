//
//  addBackground.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-11-16.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "fb2frontscreen.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
    func addFreshBitesLogo() {
        // screen width and height:
        //let width = UIScreen.mainScreen().bounds.size.width
        //let height = UIScreen.mainScreen().bounds.size.height
        let imageView = UIImageView(frame: CGRectMake(200, 300, 200, 300))
        imageView.image = UIImage(named: "freshBitesLogo.png")
        
        // you can change the content mode:
        //imageView.contentMode = UIViewContentMode.Top
        imageView.backgroundColor = UIColor.clearColor()
        imageView.opaque = false;
        
        self.addSubview(imageView)
        //self.sendSubviewToBack(imageView)
    }
}