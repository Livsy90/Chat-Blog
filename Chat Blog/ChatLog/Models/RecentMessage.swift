//
//  RecentMessage.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import Firebase

struct RecentMessage: Identifiable {
    var id: String { docId }
    
    let fromId, toId, docId: String
    let timestamp: Timestamp
    let text: String
    
    init(docId: String, dictionary: [String: Any]) {
        self.docId = docId
        self.fromId = dictionary[FirebaseConstants.fromId] as? String ?? ""
        self.toId = dictionary[FirebaseConstants.toId] as? String ?? ""
        self.text = dictionary[FirebaseConstants.text] as? String ?? ""
        self.timestamp = dictionary[FirebaseConstants.timestamp]
            as? Firebase.Timestamp ?? Firebase.Timestamp()
    }
}
