//
//  RecentMessageViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import SwiftUI

struct RecentMessageRowView: View {
    let data: MessagesList.RowData
    @EnvironmentObject private var chatLogViewModel: ChatLogViewModel
    let didSelectUser: ((ChatUser?) -> Void)?
    
    var body: some View {
        Button(action: {
            chatLogViewModel.user = data.user
            chatLogViewModel.fetchMessages()
            didSelectUser?(data.user)
        }, label: {
            HStack(spacing: 16) {
                AsyncImage(
                    url: URL(string: data.user.profileImageUrl),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                    }
                )
                .background(Color.gray)
                .cornerRadius(22)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.gray, lineWidth: 0.5))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.user.username)
                        .font(.system(size: 13, weight: .semibold))
                    Text(data.message.text)
                        .font(.system(size: 12, weight: .regular))
                }
                .foregroundColor(.primary)
                
                Spacer()
                
                Text(data.message.timeAgo)
                    .font(.system(size: 12, weight: .semibold))
            }
        })
        .padding(.horizontal, 4)
    }
}
