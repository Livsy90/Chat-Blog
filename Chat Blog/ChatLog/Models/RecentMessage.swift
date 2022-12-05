//
//  RecentMessage.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import Firebase

struct RecentMessage: Identifiable, Hashable {
    var id: String { docId }
    
    let fromId, toId, docId: String
    let timestamp: Timestamp
    let text: String
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp.dateValue(), relativeTo: Date())
    }
    
    var time: String {
        timestamp.dateValue().time
    }
    
    init(docId: String, dictionary: [String: Any]) {
        self.docId = docId
        self.fromId = dictionary[FirebaseConstants.fromId] as? String ?? ""
        self.toId = dictionary[FirebaseConstants.toId] as? String ?? ""
        self.text = dictionary[FirebaseConstants.text] as? String ?? ""
        self.timestamp = dictionary[FirebaseConstants.timestamp]
            as? Firebase.Timestamp ?? Firebase.Timestamp()
    }
}
