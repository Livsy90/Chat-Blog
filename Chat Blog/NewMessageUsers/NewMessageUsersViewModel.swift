//
//  SwiftUIView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import Foundation

final class NewMessageUsersViewModel: ObservableObject {
    
    @Published var users: [ChatUser] = []
    @Published var errorMessage = ""
    
    init() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { [weak self] (snapshot, err) in
            if let err = err {
                self?.errorMessage = err.localizedDescription
                return
            }
            
            self?.users = snapshot?.documents
                .map { ChatUser(dictionary: $0.data()) } ?? []
            let index = self?.users.firstIndex { user in
                user.uid == FirebaseManager.shared.auth.currentUser?.uid
            }
            if let index { self?.users.remove(at: index) }
        }
    }
    
}
