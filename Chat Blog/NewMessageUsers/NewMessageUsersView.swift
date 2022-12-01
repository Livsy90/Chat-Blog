//
//  NewMessageUsersView.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

struct NewMessageUsersView: View {
    
    @ObservedObject var vm = NewMessageUsersViewModel()
    @Environment(\.presentationMode) var presentationMode
    private let didSelectUser: ((ChatUser?) -> Void)?
    
    init(didSelectUser: ((ChatUser?) -> Void)?) {
        self.didSelectUser = didSelectUser
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.users, id: \.self) { user in
                    Button(action: {
                        didSelectUser?(user)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        VStack {
                            HStack(spacing: 16) {
                                AsyncImage(
                                    url: URL(string: user.profileImageUrl),
                                    content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                )
                                .cornerRadius(30)
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 2))
                                Text(user.email)
                                Spacer()
                                
                            }.padding(.horizontal)
                            
                            Divider()
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                        }
                    })
                    .foregroundColor(.black)
                }
            }.navigationTitle("New Message")
            
        }
        
    }
}
