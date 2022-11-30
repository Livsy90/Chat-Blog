//
//  MessagesList.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct MessagesList: View {
    var body: some View {
        ForEach(0..<10, id: \.self) { num in
            HStack(spacing: 16) {
                Spacer()
                    .frame(width: 40, height: 40)
                    .background(Color.black)
                    .cornerRadius(40)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dummy Username")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Message that user sent or received")
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
