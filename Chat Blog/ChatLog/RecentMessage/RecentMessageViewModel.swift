//
//  RecentMessageView.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import SwiftUI

final class RecentMessageViewModel: ObservableObject {
    
    @Published var user: ChatUser?
    
    init(recentMessage: RecentMessage) {
        FirebaseManager.shared.firestore
            .collection("users")
            .document(recentMessage.docId)
            .getDocument { document, err in
                if let err = err {
                    print("Failed to fetch user:", err)
                    return
                }
                
                guard let data = document?.data() else { return }
                
                self.user = .init(dictionary: data)
            }
    }
}
