//
//  RecentMessageViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import SwiftUI

struct RecentMessageRowView: View {
    let data: MessagesList.RowData
    let didSelectUser: ((ChatUser?) -> Void)?
    @EnvironmentObject private var chatDataSource: ChatDataSource
    
    var body: some View {
        Button(action: {
            chatDataSource.user = data.user
            chatDataSource.fetchMessages()
            didSelectUser?(data.user)
        }, label: {
            HStack(spacing: 16) {
                AsyncImage(
                    url: URL(string: data.user.profileImageUrl),
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
