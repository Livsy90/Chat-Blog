//
//  ChatLogViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI
import Firebase

final class ChatLogViewModel: ObservableObject {
    
    @Published var text = ""
    @Published var errorMessage = ""
    @Published var messages = [Message]()
    @Published var user: ChatUser?
    var listener: ListenerRegistration?
    
    init(user: ChatUser?) {
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        print("Fetching messages")
        messages.removeAll()
        guard
            let uid = FirebaseManager.shared.auth.currentUser?.uid,
            let user = user
        else { return }
        
        let collection = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(uid)
            .collection(user.uid)
            .order(by: FirebaseConstants.timestamp)
        
        listener = collection.addSnapshotListener { snapshot, err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    self.messages.append(.init(dictionary: change.document.data()))
                    print("Added message")
                }
            }
        }
    }
    
    func sendMessage() {
        print("Sending: \(text)")
        self.errorMessage = ""
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let user = user else { return }
        guard let data = textMessageData() else { return }
        
        let doc = FirebaseManager.shared.firestore
            .collection("messages").document(uid)
            .collection(user.uid).document()
        
        doc.setData(data, completion: { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            print("Message send complete")
            self.persistRecentMessageToFirestore(text: self.text)
            self.text = ""
        })
        
        let receivingUserDoc = FirebaseManager.shared.firestore
            .collection("messages").document(user.uid)
            .collection(uid).document()
        receivingUserDoc.setData(data, completion: { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            print("Recipient document set complete")
        })
    }
    
    private func textMessageData() -> [String: Any]? {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return nil }
        guard let user = user else { return nil }
        let timestamp = Firebase.Timestamp()
        return [
            FirebaseConstants.text: text,
            FirebaseConstants.timestamp: timestamp,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: user.uid
        ] as [String: Any]
    }
    
    private func persistRecentMessageToFirestore(text: String) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let user = user else { return }
        let data = [
            FirebaseConstants.timestamp: Firebase.Timestamp(),
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: user.uid,
            FirebaseConstants.text: text
        ] as [String: Any]
        
        let doc = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(user.uid)
        
        doc.setData(data) { (err) in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            print("Recent message for current user saved")
        }
        
        let receivingUserDoc = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(user.uid)
            .collection(FirebaseConstants.messages)
            .document(uid)
        receivingUserDoc.setData(data) { (err) in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            print("Recent message for recipient saved")
        }
    }
    
}
