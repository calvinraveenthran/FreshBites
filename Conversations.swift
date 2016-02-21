//
//  Conversations.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-02-18.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation

class Conversations: NSObject {
    
    var catererName: String!
    var conversationId: String!
    var newMessage: Bool!
    
    init(catererName: String,  conversationId: String, newMessage: Bool) {
        self.catererName = catererName
        self.conversationId = conversationId
        self.newMessage = newMessage
    }
    
    
}

class Message: NSObject {
    
    var sender: String!
    var conversationId: String!
    var message: String!
    
    init(sender: String,  conversationId: String, message: String) {
        self.sender = sender
        self.conversationId = conversationId
        self.message = message
    }
    
    
}
