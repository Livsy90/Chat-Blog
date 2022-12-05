//
//  ChatLogViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import Firebase
import UIKit

final class ChatDataSource: ObservableObject {
    
    static let shared = ChatDataSource(user: nil)
    
    @Published var text = ""
    @Published var errorMessage = ""
    @Published var messages = [Message]()
    @Published var user: ChatUser?
    @Published var isInitial = true
    @Published var isSendingMessage = false
    var listener: ListenerRegistration?
    
    init(user: ChatUser?) {
        self.user = user
        fetchMessages()
    }
    
    func reset() {
        user = nil
        messages.removeAll()
        text.removeAll()
    }
    
    func fetchMessages() {
        // print("Fetching messages")
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
        
        listener = collection.addSnapshotListener { [weak self] snapshot, err in
            guard let self = self else { return }
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            
            if self.messages.isEmpty {
                self.isInitial = true
                let messagesArray = snapshot?.documentChanges.compactMap {
                    if $0.type == .added {
                       return Message(dictionary: $0.document.data())
                    } else {
                        return nil
                    }
                }
                
                self.messages = messagesArray ?? []
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.isInitial = self.messages.isEmpty
                }
                return
            }
            
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    self.messages.append(.init(dictionary: change.document.data()))
                    //  print("Added message")
                }
            }
        }
    }
    
    func sendMessage() {
        // print("Sending: \(text)")
        self.errorMessage = ""
        self.isSendingMessage = true
        let savedText = self.text
        
        guard let user = user,
              let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let data = textMessageData(text: text)
        else { return }
        
        self.text = ""
        let doc = FirebaseManager.shared.firestore
            .collection("messages").document(uid)
            .collection(user.uid).document()
        
        doc.setData(data, completion: { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                self.text = savedText
                return
            }
            // print("Message send complete")
            self.isSendingMessage = false
            self.persistRecentMessageToFirestore(text: savedText)
        })
        
        let receivingUserDoc = FirebaseManager.shared.firestore
            .collection("messages").document(user.uid)
            .collection(uid).document()
        receivingUserDoc.setData(data, completion: { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            // print("Recipient document set complete")
        })
    }
    
    func sendImage(_ image: UIImage) {
        // print("Sending: \(text)")
        
        self.errorMessage = ""
        self.isSendingMessage = true
        let string = image.base64String
        
        guard let user = user,
              let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let data = textMessageData(text: string)
        else { return }
        
        let doc = FirebaseManager.shared.firestore
            .collection("messages").document(uid)
            .collection(user.uid).document()
        
        doc.setData(data, completion: { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            // print("Message send complete")
            self.isSendingMessage = false
            self.persistRecentMessageToFirestore(text: string)
        })
        
        let receivingUserDoc = FirebaseManager.shared.firestore
            .collection("messages").document(user.uid)
            .collection(uid).document()
        receivingUserDoc.setData(data, completion: { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            // print("Recipient document set complete")
        })
    }
    
    private func textMessageData(text: String) -> [String: Any]? {
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
            // print("Recent message for current user saved")
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
            // print("Recent message for recipient saved")
        }
    }
    
}
