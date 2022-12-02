//
//  MainMessagesViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI
import Firebase

final class MainMessageViewModel: ObservableObject {
    
    @Published var shouldShowLoginModal = false
    @Published var shouldShowNewMessageModal = false
    @Published var shouldShowChatLogView = false
    @Published var selectedChatUser: ChatUser?
    @Published var errorMessage = ""
    @Published var messagesList = [RecentMessage]()
    var recentMessages = [String: RecentMessage]()
    private var listener: ListenerRegistration?
    
    init() {
        shouldShowLoginModal = FirebaseManager.shared.auth.currentUser?.uid == nil
        listenForRecentMessages()
    }
    
    private func listenForRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let collection = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
        listener = collection.addSnapshotListener { (snapshot, err) in
            
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            
            snapshot?.documentChanges.forEach { change in
                let docId = change.document.documentID
                let data = change.document.data()
                let recentMessage = RecentMessage(docId: docId, dictionary: data)
                self.recentMessages[docId] = recentMessage
                print("Appended recent message")
            }
            
            self.messagesList = self.recentMessages
                .map { key, value in return value }
                .sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
    }
    
}
