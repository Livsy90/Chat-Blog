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
    @Published var rowData = [ChatDataSource.RowData]()
    var recentMessages = [String: RecentMessage]()
    private var listener: ListenerRegistration?
    private var isInitial = true
    
    init() {
        shouldShowLoginModal = FirebaseManager.shared.auth.currentUser?.uid == nil
        listenForRecentMessages()
    }
    
    func reloadData() {
        rowData = rowData
    }
    
    func update() {
        recentMessages.removeAll()
        messagesList.removeAll()
        rowData.removeAll()
        listenForRecentMessages()
    }
    
    private func configureMessageListData() {
        rowData.removeAll()
        messagesList.forEach { recentMessage in
            FirebaseManager.shared.firestore
                .collection("users")
                .document(recentMessage.docId)
                .getDocument { [weak self] document, err in
                    if let err = err {
                        print("Failed to fetch user:", err)
                        return
                    }
                    
                    guard let data = document?.data() else { return }
                    let user = ChatUser(dictionary: data)
                    self?.rowData.append(.init(id: recentMessage.docId, user: user, message: recentMessage))
                }
        }
    }
    
    private func listenForRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let collection = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
        listener = collection.addSnapshotListener { [weak self] snapshot, err in
            
            if let err = err {
                self?.errorMessage = err.localizedDescription
                return
            }
            
            snapshot?.documentChanges.forEach { change in
                let docId = change.document.documentID
                let data = change.document.data()
                let recentMessage = RecentMessage(docId: docId, dictionary: data)
                self?.recentMessages[docId] = recentMessage
               // print("Appended recent message")
            }
            
            withAnimation(.spring()) {
                self?.messagesList = self?.recentMessages
                    .map { key, value in return value }
                    .sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) ?? []
                self?.configureMessageListData()
            }
        }
    }
    
}
