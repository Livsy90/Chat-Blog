//
//  MessagesList.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MessagesList: View {
    
    let recentMessages: [RecentMessage]
    let didSelectUser: ((ChatUser?) -> Void)?
    var body: some View {
        
        VStack {
            ForEach(recentMessages) { recentMessage in
                VStack {
                    RecentMessageRowView(recentMessage: recentMessage) { user in
                        didSelectUser?(user)
                    }
                    .padding(.horizontal)
                    Divider()
                }
            }
            .padding(.top, 8)
        }
    }
    
}
