//
//  MessagesList.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MessagesList: View {
    
    struct RowData: Identifiable {
        var id: String
        var user: ChatUser
        var message: RecentMessage
    }
    
    let data: [RowData]
    let didSelectUser: ((ChatUser?) -> Void)?
    var body: some View {
        
        VStack {
            ForEach(data) { item in
                VStack {
                    RecentMessageRowView(data: item) { user in
                        didSelectUser?(user)
                    }
                    .padding(.horizontal)
                    Divider()
                        .padding(.horizontal)
                }
            }
            .padding(.top, 8)
        }
    }
    
}
