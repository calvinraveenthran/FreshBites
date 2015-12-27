//
//  BackTableViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-25.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//


class BackTableViewController: UITableViewController {
    
    var backTableArray = [String]()
    
    override func viewDidLoad() {
        backTableArray = ["Menu", "Reviews"]
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backTableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(backTableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = backTableArray[indexPath.row]
        
        return cell
    }
    
}

    



