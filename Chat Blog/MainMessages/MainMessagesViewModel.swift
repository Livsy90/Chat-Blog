//
//  MainMessagesViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

final class MainMessageViewModel: ObservableObject {
    
    @Published var shouldShowLoginModal = false
    @Published var shouldShowNewMessageModal = false
    @Published var shouldShowChatLogView = false
    @Published var selectedChatUser: ChatUser?
    
    init() {
        shouldShowLoginModal = FirebaseManager.shared.auth.currentUser?.uid == nil
    }
    
}
