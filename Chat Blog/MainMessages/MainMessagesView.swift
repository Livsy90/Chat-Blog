//
//  MainMessagesView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MainMessagesView: View {
    
    @ObservedObject var vm = MainMessageViewModel()
    private var chatDataSource = ChatDataSource.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(vm.rowData) { item in
                        RecentMessageRowView(data: item) { user in
                            vm.selectedChatUser = user
                            vm.shouldShowChatLogView.toggle()
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                chatDataSource.readAll(userID: item.user.uid)
                                vm.reloadData()
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.white)
                            }
                            .tint(.blue)
                        }
                    }
                }
                    .preferredColorScheme(.light)
                    .environmentObject(chatDataSource)
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Messages")
            .onAppear {
                chatDataSource.listener?.remove()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        try? FirebaseManager.shared.auth.signOut()
                        vm.shouldShowLoginModal = true
                        chatDataSource.reset()
                    }, label: {
                        Text("Log Out")
                    })
                    .tint(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.shouldShowNewMessageModal.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .tint(.primary)
                }
            }
            .navigationDestination(isPresented: $vm.shouldShowChatLogView) {
                ChatLogView(chatDataSource: chatDataSource)
                    .preferredColorScheme(.light)
            }
            .sheet(isPresented: $vm.shouldShowNewMessageModal, content: {
                NewMessageUsersView { user in
                    vm.selectedChatUser = user
                    vm.shouldShowChatLogView.toggle()
                    chatDataSource.user = user
                    chatDataSource.listener?.remove()
                    chatDataSource.fetchMessages()
                }
            })
            .fullScreenCover(isPresented: $vm.shouldShowLoginModal, content: {
                LoginView() {
                    vm.update()
                }
                .preferredColorScheme(.light)
            })
        }
    }
    
}
