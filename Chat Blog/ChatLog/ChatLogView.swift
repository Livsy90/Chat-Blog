//
//  ChatLogView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct ChatLogView: View {
    
    @ObservedObject private var vm: ChatLogViewModel
    
    private let user: ChatUser
    
    init(user: ChatUser) {
        self.user = user
        self.vm = .init(user: user)
    }
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 8)
            ForEach(vm.messages, id: \.self) { message in
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                    if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                        BlueMessageView(message: message.text)
                    } else {
                        WhiteMessageView(message: message.text)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 64)
        .navigationTitle(user.email)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.init(white: 0, alpha: 0.05)))
        .overlay(ChatLogBottomSendBarView(text: $vm.text, sendMessageHandler: vm.sendMessage), alignment: .bottom)
    }
}

private struct ChatLogBottomSendBarView: View {
    
    @Binding var text: String
    let sendMessageHandler: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                
                ZStack {
                    TextEditorPlaceholder()
                    TextEditor(text: $text)
                        .opacity(text.isEmpty ? 0.5 : 1)
                }
                .frame(height: 40)
                Spacer()
                Button(action: sendMessageHandler, label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .font(.system(size: 14, weight: .bold))
                }).background(Color.blue)
                    .cornerRadius(3)
            }
            .padding(12)
            .background(Color(.lightGray))
        }
    }
}

private struct BlueMessageView: View {
    
    @State var message: String
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Text(message)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(6)
        }
    }
}

private struct WhiteMessageView: View {
    
    @State var message: String
    
    var body: some View {
        HStack {
            HStack {
                Text(message)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(6)
            Spacer()
        }
        
    }
}

private struct TextEditorPlaceholder: View {
    
    var body: some View {
        HStack {
            Text("Enter message")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
