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
        NavigationStack {
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
                                .cornerRadius(30)
                                
                                Text(user.username)
                                    .font(.system(size: 15, weight: .semibold))
                                Spacer()
                                
                            }.padding(.horizontal)
                            
                            Divider()
                                .padding()
                        }
                    })
                    .foregroundColor(.black)
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
