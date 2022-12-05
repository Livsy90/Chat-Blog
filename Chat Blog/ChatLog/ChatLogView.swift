//
//  ChatLogView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct ChatLogView: View {
    
    @ObservedObject var chatDataSource: ChatDataSource
    
    var body: some View {
        
        VStack {
            Color.clear.frame(height: 1)
            
            ScrollViewReader { value in
                ScrollView {
                    Spacer().frame(height: 8)
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                        ForEach(Array(zip(chatDataSource.messages.indices, chatDataSource.messages)), id: \.0) { index, message in
                            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                                BlueMessageView(message: message.text)
                                    .tag(index)
                            } else {
                                WhiteMessageView(message: message.text)
                                    .tag(index)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 88)
                .padding(.top, 1)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AsyncImage(
                            url: URL(string: chatDataSource.user?.profileImageUrl ?? ""),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 44, height: 44)
                            },
                            placeholder: {
                                ActivityIndicator()
                                    .foregroundColor(Color(.systemGray5))
                                    .frame(width: 44, height: 44)
                                    .background(Color.white)
                            }
                        )
                        .cornerRadius(22)
                    }
                    ToolbarItem(placement: .principal) {
                        Text(chatDataSource.user?.username ?? "")
                            .font(.system(size: 15, weight: .semibold))
                        
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.systemGray5))
                .frame(maxWidth: .infinity)
                .overlay(ChatLogBottomSendBarView(
                    text: $chatDataSource.text,
                    isSending: $chatDataSource.isSendingMessage,
                    sendMessageHandler: chatDataSource.sendMessage
                ), alignment: .bottom)
                .onDisappear {
                    chatDataSource.user = nil
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: chatDataSource.messages) { _ in
                    if chatDataSource.isInitial {
                        value.scrollTo(chatDataSource.messages.count - 1)
                    } else {
                        withAnimation {
                            value.scrollTo(chatDataSource.messages.count - 1)
                        }
                    }
                }
                .onReceive(keyboardPublisher) { _ in
                    withAnimation {
                        value.scrollTo(chatDataSource.messages.count - 1)
                    }
                }
            }
        }
        
    }
}

private struct ChatLogBottomSendBarView: View {
    
    @Binding var text: String
    @Binding var isSending: Bool
    
    let sendMessageHandler: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 2) {
                TextField("Enter message", text: $text, axis: .vertical)
                    .lineLimit(1...2)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                
                Button(action: sendMessageHandler, label: {
                    ZStack {
                        Circle()
                            .fill(text.isEmpty ? Color.gray : Color.blue)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "arrow.up")
                            .foregroundColor(text.isEmpty ? Color(.systemGray5) : Color.white)
                    }
                })
                .disabled(text.isEmpty || isSending)
                .padding(.trailing, 6)
            }
            .padding()
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
            .clipShape(ChatBubble(isMyMsg: true))
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
            .clipShape(ChatBubble(isMyMsg: false))
            Spacer()
        }
        
    }
}

struct ChatBubble: Shape {
    
    var isMyMsg: Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isMyMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}
