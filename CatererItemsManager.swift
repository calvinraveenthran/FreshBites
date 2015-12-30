//
//  CatererItemsManager.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-29.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI

class CatererItemsManager: NSObject {
    
    static let sharedManager = CatererItemsManager()
    var resultItems = [CatererItem]()
    
    private override init() {}
    
}
