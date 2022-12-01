//
//  ChatLogView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct ChatLogView: View {
    
    @ObservedObject var vm: ChatLogViewModel
    
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
        .navigationTitle(vm.user?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.init(white: 0, alpha: 0.05)))
        .frame(maxWidth: .infinity)
        .overlay(ChatLogBottomSendBarView(text: $vm.text, sendMessageHandler: vm.sendMessage), alignment: .bottom)
        .onDisappear {
            vm.user = nil
        }
    }
}

private struct ChatLogBottomSendBarView: View {
    
    @Binding var text: String
    let sendMessageHandler: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                TextField("Enter message", text: $text, axis: .vertical)
                    .lineLimit(1...3)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessageHandler, label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .font(.system(size: 14, weight: .bold))
                })
                .background(Color.blue)
                .cornerRadius(3)
            }
            .padding(12)
            .background(Color(.systemGray5))
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
