//
//  Feedback.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-27.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit

class Feedback: NSObject {
    
    var name: String
    var text: String
    var numberOfStars: Int
    
    override init() {
        name = ""
        text = ""
        numberOfStars = 1
    }
    
    init(name: String, text: String, numberOfStars: Int) {
        self.name = name
        self.text = text
        self.numberOfStars = numberOfStars
    }
}