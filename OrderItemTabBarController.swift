//
//  OrderItemTabBarController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-22.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse
import ParseUI



protocol OrderItemTabBarControllerDelegate{
    func appendToCheckoutMaster(childCheckoutObject:OrderItem)
}

class OrderItemTabBarController: UITabBarController, FoodScrollViewController2Delegate {
    
    //var targetMenu: MenuItem!
    //var checkoutArray: [OrderItem] = UserSessionManager.userSharedManager.checkoutArray
    
    var myDelegate: OrderItemTabBarControllerDelegate! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
            
    }
    
    func appendToCheckout(childCheckoutObject:OrderItem) {        
        myDelegate.appendToCheckoutMaster(childCheckoutObject)
        //UserSessionManager.userSharedManager.checkoutArray.append(childCheckoutObject)
        //checkoutArray = UserSessionManager.userSharedManager.checkoutArray
    }
    
}
