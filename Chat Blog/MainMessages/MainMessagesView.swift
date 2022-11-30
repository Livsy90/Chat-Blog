//
//  MainMessagesView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MainMessagesView: View {
    
    @ObservedObject var vm = MainMessageViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    if FirebaseManager.shared.auth.currentUser?.uid == nil {
                        Text("User is not signed in")
                    } else {
                        MessagesList()
                            .fullScreenCover(isPresented: $vm.shouldShowNewMessageModal, content: {
                                NewMessageUsersView { user in
                                    vm.selectedChatUser = user
                                    vm.shouldShowChatLogView.toggle()
                                }
                            })
                    }
                    
                    if let user = vm.selectedChatUser {
                        NavigationLink("", destination: ChatLogView(user: user), isActive: $vm.shouldShowChatLogView)
                    }
                    
                    Spacer()
                        .fullScreenCover(isPresented: $vm.shouldShowLoginModal, content: {
                            LoginView()
                        })
                }.overlay(
                    Button(action: { vm.shouldShowNewMessageModal.toggle() }, label: {
                        HStack {
                            Spacer()
                            Text("New Message")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                            Spacer()
                        }.background(Color.blue)
                            .cornerRadius(24)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0.4784809947, blue: 0.9998757243, alpha: 0.2469350594)), radius: 10)
                    }).padding(), alignment: .bottom)
            }
            .navigationBarItems(leading: Button(action: {
                try? FirebaseManager.shared.auth.signOut()
                vm.shouldShowLoginModal = true
            }, label: {
                Text("Log Out")
            }))
            .navigationTitle("Main Messages")
        }
    }
    
}
