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
                AsyncImage(
                    url: URL(string: vm.user?.profileImageUrl ?? ""),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 44, height: 44)
                    }
                )
                .background(Color.gray)
                .cornerRadius(22)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.gray, lineWidth: 0.5))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.user?.email ?? "")
                        .font(.system(size: 13, weight: .semibold))
                    Text(recentMessage.text)
                        .font(.system(size: 12, weight: .regular))
                }
                .foregroundColor(.primary)
                
                Spacer()
                
                Text(recentMessage.timeAgo)
                    .font(.system(size: 12, weight: .bold))
            }
        })
        .padding(.horizontal, 4)
    }
}
