//
//  Message.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import Foundation

struct Message: Hashable {
    let fromId, toId, text: String
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary[FirebaseConstants.fromId] as? String ?? ""
        self.toId = dictionary[FirebaseConstants.toId] as? String ?? ""
        self.text = dictionary[FirebaseConstants.text] as? String ?? ""
    }
}
