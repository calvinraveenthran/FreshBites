//
//  ReviewsViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI

enum ButtonAction: Int {
    case ADD = 0, MINUS
}


protocol CheckoutTableViewCellDelegate {
    func cellTapped(cell: CheckoutTableViewCell, action: Int)
}

class CheckoutViewController : UIViewController, CheckoutTableViewCellDelegate, PayPalPaymentDelegate{ 
    var checkoutArray: [OrderItem] = UserSessionManager.userSharedManager.checkoutArray
    var totalSum: Int = 0
    var payPalConfig = PayPalConfiguration()
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var menu: UIBarButtonItem!
    @IBOutlet weak var checkoutTableView: UITableView!
    
    @IBAction func updateShoppingCartButton(sender: AnyObject) {
        updatePrice()
    }
    
   
    
    
    @IBAction func proceedToCheckoutButton(sender: AnyObject) {
        
        let queue = NSOperationQueue()
        var Items : [PayPalItem] = []

        
    queue.addOperationWithBlock() {
            for foodOrder in UserSessionManager.userSharedManager.checkoutArray {
                let orderSend = PFObject(className:"Orders")
            
                orderSend["customer"] = PFUser.currentUser()?.username
                orderSend["foodName"] = foodOrder.name
                orderSend["menuId"] = foodOrder.objectID
                orderSend["quantity"] = foodOrder.quantity
                orderSend["details"] = foodOrder.comments
                orderSend["price"] = foodOrder.price.integerValue
                orderSend["caterer"] = foodOrder.owner


                orderSend.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                    // The object has been saved.
                                    let item1 = PayPalItem(name: foodOrder.objectID, withQuantity: UInt(foodOrder.quantity), withPrice:foodOrder.price, withCurrency: "CAD", withSku:"0000")
                                    Items.append(item1)
                            } else {
                                    // There was a problem, check error.description
                            }
                
                            //4.    When Downloading is Finished (Join queue)
                            NSOperationQueue.mainQueue().addOperationWithBlock() {
                                if Items.count == UserSessionManager.userSharedManager.checkoutArray.count{
                    
                                    let subtotal = PayPalItem.totalPriceForItems(Items)
                        
                                    // Optional: include payment details
                                    let shipping = NSDecimalNumber(string: "0.00")
                                    let tax = NSDecimalNumber(string: "0.00")
                                    let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
                        
                                    let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
                        
                                    let payment = PayPalPayment(amount: total, currencyCode: "CAD", shortDescription: "Calvin R Test", intent: .Sale)
                        
                                    payment.items = Items
                                    payment.paymentDetails = paymentDetails
                        
                        
                                    UserSessionManager.userSharedManager.checkoutArray.removeAll()
                                    self.checkoutArray = UserSessionManager.userSharedManager.checkoutArray
                                    self.priceLabel.text = "0"
                                    self.checkoutTableView.reloadData()
                        
                                    if (payment.processable) {
                                        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: self.payPalConfig, delegate: self)
                                        self.presentViewController(paymentViewController!, animated: true, completion: nil)
                                    }
                                    else {
                            
                                        print("Payment not processalbe: \(payment)")
                                    }
                    
                                }
                    
                    }
                
                }
            
            }
        }
        
    }
    
    var environment:String = PayPalEnvironmentSandbox
        
        
    /*PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }*/
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        super.viewDidLoad()
        checkoutTableView.dataSource = self
        UpdatePriceLabel()
        
        
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "Calvin Raveenthran Inc."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0]
        payPalConfig.payPalShippingAddressOption = .PayPal;
        
        PayPalMobile.preconnectWithEnvironment(self.environment)
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        print("PayPal Payment Cancelled")
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        
        print("PayPal Payment Success !")
        paymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        })
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
            totalSum += self.checkoutArray[i].quantity*self.checkoutArray[i].price.integerValue
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
