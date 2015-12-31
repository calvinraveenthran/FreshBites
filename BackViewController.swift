//
//  BackViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-31.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation
class BackViewController: UIViewController {

    
    @IBOutlet weak var backTableView: UITableView!
    var  backTableArray = ["Menu", "Checkout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.midnightBlueColor()
        self.backTableView.backgroundColor = UIColor.midnightBlueColor()
        self.backTableView.dataSource = self
        self.backTableView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
    
    
// MARK: - UITableViewDataSource
extension BackViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return backTableArray.count
        }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(backTableArray[indexPath.row], forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = backTableArray[indexPath.row]
        cell.backgroundColor = UIColor.midnightBlueColor()
        
        return cell
    }

}

extension BackViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.backTableView.reloadData()
    }
}
