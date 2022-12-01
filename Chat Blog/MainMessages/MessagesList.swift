//
//  MessagesList.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MessagesList: View {
    
    let recentMessages: [RecentMessage]
    
    var body: some View {
        ForEach(recentMessages) { recentMessage in
            HStack(spacing: 16) {
                Spacer()
                    .frame(width: 40, height: 40)
                    .background(Color.green)
                    .cornerRadius(40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(recentMessage.fromId)
                        .font(.system(size: 15, weight: .semibold))
                    Text(recentMessage.text)
                        .font(.system(size: 13, weight: .regular))
                }
                
                Spacer()
                Text("2m ago")
                    .font(.system(size: 12))
            }.padding(.horizontal)
            Divider()
            
        }.padding(.top, 8)
    }
}
