//
//  ReviewsViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation

class CheckoutViewController : UIViewController{
    
    
    @IBOutlet weak var priceLabel: UILabel!   
    @IBOutlet var menu: UIBarButtonItem!
    @IBOutlet weak var checkoutTableView: UITableView!
    
    var checkoutArray: [OrderItem] = UserSessionManager.userSharedManager.checkoutArray
   
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        super.viewDidLoad()
        checkoutTableView.dataSource = self
            
    }

}

extension CheckoutViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkoutArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CheckoutTableViewCell = tableView.dequeueReusableCellWithIdentifier("checkoutCell") as! CheckoutTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let review = checkoutArray[indexPath.row]
        
        cell.foodItemName.text = review.name
        cell.foodItemComments.text = review.comments
        cell.itemQuantityLabel.text = "\(review.quantity)"
        return cell
    }
}
