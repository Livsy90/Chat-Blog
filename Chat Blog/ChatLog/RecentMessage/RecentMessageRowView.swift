//
//  RecentMessageViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 01.12.2022.
//

import SwiftUI

struct RecentMessageRowView: View {
    let data: ChatDataSource.RowData
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
                    if let image = data.message.text.base64Image {
                        Image(uiImage: image.preparingThumbnail(of: .init(width: 100, height: 100)) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 12, maxHeight: 12)
                    } else {
                        Text(data.message.text)
                            .font(.system(size: 12, weight: .regular))
                    }
                }
                .foregroundColor(.primary)
                
                Spacer()
                
                HStack {
                    Text(data.message.timeAgo)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                    
                    if chatDataSource.hasUnread(userID: data.user.uid) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12)
                    }
                }
            }
        })
        .padding(.horizontal, 4)
    }
}
