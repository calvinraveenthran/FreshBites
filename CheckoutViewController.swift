//
//  ReviewsViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation

enum ButtonAction: Int {
    case ADD = 0, MINUS
}


protocol CheckoutTableViewCellDelegate {
    func cellTapped(cell: CheckoutTableViewCell, action: Int)
}

class CheckoutViewController : UIViewController, CheckoutTableViewCellDelegate{
    var checkoutArray: [OrderItem] = UserSessionManager.userSharedManager.checkoutArray
    var totalSum: Int = 0
    
    @IBOutlet weak var priceLabel: UILabel!   
    @IBOutlet var menu: UIBarButtonItem!
    @IBOutlet weak var checkoutTableView: UITableView!
    
    @IBAction func updateShoppingCartButton(sender: AnyObject) {
        updatePrice()
    }
    
   
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        super.viewDidLoad()
        checkoutTableView.dataSource = self
        UpdatePriceLabel()
            
    }
    
    func cellTapped(cell: CheckoutTableViewCell, action: Int) {
        
        let row = checkoutTableView.indexPathForCell(cell)!.row
        
        
            if action == ButtonAction.ADD.rawValue && self.checkoutArray[row].quantity < 10{
                self.checkoutArray[row].quantity  = self.checkoutArray[row].quantity + 1
            }else if action == ButtonAction.MINUS.rawValue && self.checkoutArray[row].quantity > 0{
                self.checkoutArray[row].quantity  = self.checkoutArray[row].quantity - 1
            }
            
            self.checkoutTableView.reloadData()
    }
    
    func updatePrice(){
        for var i = 0; i < self.checkoutArray.count ; ++i {
            UserSessionManager.userSharedManager.checkoutArray[i].quantity = self.checkoutArray[i].quantity
        }
        UpdatePriceLabel()
    }
    
    func UpdatePriceLabel(){
        totalSum = 0
        for var i = 0; i < self.checkoutArray.count ; ++i {
            totalSum += self.checkoutArray[i].quantity*self.checkoutArray[i].price
        }
        self.priceLabel.text = "\(totalSum)"
    }

}

extension CheckoutViewController: UITableViewDataSource{
    
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
        
        
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self
        }
        
        return cell
    }
    

}
