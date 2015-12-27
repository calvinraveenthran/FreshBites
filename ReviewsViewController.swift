//
//  ReviewsViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation

class ReviewsViewController : UIViewController{
   
    @IBOutlet var menu: UIBarButtonItem!
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

}
