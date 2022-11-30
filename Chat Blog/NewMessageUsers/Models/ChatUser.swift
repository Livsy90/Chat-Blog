//
//  ChatUser.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import Foundation

struct ChatUser: Hashable {
    let email, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
