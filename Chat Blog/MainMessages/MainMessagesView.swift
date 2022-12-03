//
//  MainMessagesView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MainMessagesView: View {
    
    @ObservedObject var vm = MainMessageViewModel()
    private var chatLogViewModel = ChatLogViewModel(user: nil)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    if FirebaseManager.shared.auth.currentUser?.uid == nil {
                        Text("User is not signed in")
                    } else {
                        MessagesList(data: vm.rowData) { user in
                            vm.selectedChatUser = user
                            vm.shouldShowChatLogView.toggle()
                        }
                        .preferredColorScheme(.light)
                        .environmentObject(chatLogViewModel)
                        .fullScreenCover(isPresented: $vm.shouldShowNewMessageModal, content: {
                            NewMessageUsersView { user in
                                vm.selectedChatUser = user
                                vm.shouldShowChatLogView.toggle()
                                chatLogViewModel.user = user
                                chatLogViewModel.listener?.remove()
                                chatLogViewModel.fetchMessages()
                            }
                        })
                    }
                    
                    if let _ = vm.selectedChatUser {
                        NavigationLink("", destination: ChatLogView(vm: chatLogViewModel).preferredColorScheme(.light), isActive: $vm.shouldShowChatLogView)
                    }
                    
                    Spacer()
                        .fullScreenCover(isPresented: $vm.shouldShowLoginModal, content: {
                            LoginView()
                                .preferredColorScheme(.light)
                        })
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarItems(leading: Button(action: {
                try? FirebaseManager.shared.auth.signOut()
                vm.shouldShowLoginModal = true
            }, label: {
                Text("Log Out")
            }))
            .navigationTitle("Messages")
            .onAppear {
                chatLogViewModel.listener?.remove()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.shouldShowNewMessageModal.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .tint(.primary)
                }
            }
        }
    }
    
}
