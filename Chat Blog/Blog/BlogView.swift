//
//  BlogView.swift
//  Chat Blog
//
//  Created by Livsy on 06.12.2022.
//

import SwiftUI

struct BlogView: View {
    @ObservedObject var vm = BlogViewModel()
    @State var isShowPost: Bool
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                if let posts = vm.posts {
                    
                    if posts.isEmpty {
                        
                        (
                            Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                            +
                            
                            Text("Start writing")
                        )
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    }
                    else {
                        
                        List(posts) { post in
                            
                            CardView(post: post)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    
                                    Button(role: .destructive) {
                                        vm.deletePost(post: post)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    
                                }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                else {
                    ActivityIndicator()
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                }
            }
            .navigationTitle("Blog")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(
            Button(action: {
                vm.createPost.toggle()
            }, label: {
                
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(scheme == .dark ? Color.black : Color.white)
                    .padding()
                    .background(.primary, in: Circle())
            })
            .padding()
            .foregroundStyle(.primary)
            
            ,alignment: .bottomTrailing
        )
        .task {
            await vm.fetchPosts()
        }
        .fullScreenCover(isPresented: $vm.createPost, content: {
            
            CreatePost()
                .overlay(
                    ZStack {
                        Color.primary.opacity(0.25)
                            .ignoresSafeArea()
                        
                        ActivityIndicator()
                            .foregroundColor(Color(.systemGray5))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                    }
                        .opacity(vm.isWriting ? 1 : 0)
                )
                .environmentObject(vm)
        })
        .alert(vm.alertMsg, isPresented: $vm.showAlert) {
            
        }
        .sheet(isPresented: $isShowPost, content: {
            PostView(post: vm.post)
                .preferredColorScheme(.light)
        })
    }
    
    @ViewBuilder
    private func CardView(post: Post) -> some View {
        
        Button {
            vm.post = post
            isShowPost = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                
                Text(post.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("author: \(post.author)")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    private func PostView(post: Post) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text("author: \(post.author)")
                    .foregroundColor(.gray)
                
                ForEach(post.postContent) { content in
                    if content.type == .Image {
                        WebImage(url: content.value)
                    } else {
                        Text(content.value)
                            .font(.system(size: getFontSize(type: content.type)))
                            .lineSpacing(10)
                    }
                }
            }
            .padding()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
