//
//  MenuViewController.swift
//  test
//
//  Created by Calvin Raveenthran on 2015-12-25.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit

class MenuTableViewController:  UITableViewController {
    @IBOutlet weak var menu: UIBarButtonItem!
    
    
    private var menuItems: [MenuItem] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        menuItems = MenuItemsManager.sharedManager.loadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MenuItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuItemTableViewCell") as! MenuItemTableViewCell
        let item = menuItems[indexPath.row]
        
        //display data from MenuItems.plist
        cell.menuItemNameLabel?.text = item.name
        cell.ingredientsItemLabel?.text = item.ingredients
        cell.priceItemLabel?.text = item.price
        cell.menuItemImageView?.image = UIImage(named: item.image)
        
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}


