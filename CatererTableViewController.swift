//
//  CatererTableViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

class CatererTableViewController:  UITableViewController {
    
    
    private var CatererItems: [CatererItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Retrieve Messages from Parse
        //CatererItems = MenuItemsManager.sharedManager.retrieveMenu()
        //menuItems = MenuItemsManager.sharedManager.loadData()
    }
    
    
  /*  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MenuItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuItemTableViewCell") as! MenuItemTableViewCell
        let item = menuItems[indexPath.row]
        
        //display data from MenuItems.plist
        cell.menuItemNameLabel?.text = item.name
        cell.ingredientsItemLabel?.text = item.ingredients
        cell.priceItemLabel?.text = item.price
        cell.menuItemImageView?.image =  item.image
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
}
