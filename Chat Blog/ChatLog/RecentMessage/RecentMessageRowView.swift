//
//  RecentMessageViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import SwiftUI

struct RecentMessageRowView: View {
    let recentMessage: RecentMessage
    
    @ObservedObject var vm: RecentMessageViewModel
    @EnvironmentObject private var chatLogViewModel: ChatLogViewModel
    let didSelectUser: ((ChatUser?) -> Void)?
    
    init(
        recentMessage: RecentMessage,
        _ didSelectUser: ((ChatUser?) -> Void)?
    ) {
        self.recentMessage = recentMessage
        self.didSelectUser = didSelectUser
        vm = .init(recentMessage: recentMessage)
    }
    
    var body: some View {
        Button(action: {
            chatLogViewModel.user = vm.user
            chatLogViewModel.fetchMessages()
            didSelectUser?(vm.user)
        }, label: {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: vm.user?.profileImageUrl ?? ""))
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .background(Color.black)
                    .cornerRadius(44)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.user?.email ?? "")
                        .font(.system(size: 15, weight: .semibold))
                    Text(recentMessage.text)
                        .font(.system(size: 13, weight: .regular))
                }
                .foregroundColor(.primary)
                
                Spacer()
            }
        })
        .padding(.horizontal)
    }
}
