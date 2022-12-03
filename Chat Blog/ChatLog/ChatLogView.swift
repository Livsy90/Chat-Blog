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
        ScrollViewReader { value in
            ScrollView {
                Spacer().frame(height: 8)
                ForEach(Array(zip(vm.messages.indices, vm.messages)), id: \.0) { index, message in
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                        if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                            BlueMessageView(message: message.text)
                                .tag(index)
                        } else {
                            WhiteMessageView(message: message.text)
                                .tag(index)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 64)
            .navigationTitle(vm.user?.username ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.init(white: 0, alpha: 0.05)))
            .frame(maxWidth: .infinity)
            .overlay(ChatLogBottomSendBarView(text: $vm.text, sendMessageHandler: vm.sendMessage), alignment: .bottom)
            .onDisappear {
                vm.user = nil
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: vm.messages) { _ in
                withAnimation {
                    value.scrollTo(vm.messages.count - 1)
                }
            }
            .onReceive(keyboardPublisher) { _ in
                withAnimation {
                    value.scrollTo(vm.messages.count - 1)
                }
            }
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
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(text.isEmpty ? Color.gray : Color.blue)
                })
                .disabled(text.isEmpty)
                .padding(.trailing)
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

    var isMyMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isMyMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}
