//
//  MainViewController.swift
//  test
//
//  Created by Calvin Raveenthran on 2015-12-25.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}
