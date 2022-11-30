//
//  SwiftUIView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

final class NewMessageUsersViewModel: ObservableObject {
    
    @Published var users: [ChatUser] = []
    @Published var errorMessage = ""
    
    init() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            
            self.users = snapshot?.documents.map{ChatUser(dictionary: $0.data())} ?? []
        }
    }
    
}
