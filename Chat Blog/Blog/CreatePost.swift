//
//  CreatePost.swift
//  Chat Blog
//
//  Created by Livsy on 06.12.2022.
//

import SwiftUI

struct CreatePost: View {
    @EnvironmentObject var blogData : BlogViewModel
    
    @State var postTitle = ""
    @State var authorName = ""
    @State var postContent: [PostContent] = []
    
    @FocusState var showKeyboard: Bool
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack(spacing: 15) {
                    
                    VStack(alignment: .leading) {
                        
                        TextField("Post Title", text: $postTitle)
                            .font(.title2)
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading,spacing: 11) {
                        
                        Text("Author:")
                            .font(.caption.bold())
                        
                        TextField(FirebaseManager.shared.auth.currentUser?.email?.components(separatedBy: "@")[0] ?? "User", text: $authorName)
                        
                        Divider()
                    }
                    .padding(.top,5)
                    .padding(.bottom,20)
                    
                    ForEach($postContent) { $content in
                        
                        VStack{
                            
                            if content.type == .Image {
                                
                                if content.showImage && content.value != "" {
                                    
                                    WebImage(url: content.value)
                                        .onTapGesture {
                                            withAnimation{
                                                content.showImage = false
                                            }
                                        }
                                }
                                else {
                                    
                                    VStack {
                                        
                                        TextField("Image URL", text: $content.value, onCommit:  {
                                            
                                            withAnimation {
                                                content.showImage = true
                                            }
                                        })
                                        
                                        Divider()
                                    }
                                    .padding(.leading,5)
                                }
                            }
                            else{
                                
                                TextView(text: $content.value, height: $content.height, fontSize: getFontSize(type: content.type))
                                    .focused($showKeyboard)
                                    .frame(height: content.height == 0 ? getFontSize(type: content.type) * 2 : content.height)
                                    .background(
                                        
                                        Text(content.type.rawValue)
                                            .font(.system(size: getFontSize(type: content.type)))
                                            .foregroundColor(.gray)
                                            .opacity(content.value == "" ? 0.7 : 0)
                                            .padding(.leading,5)
                                        
                                        ,alignment: .leading
                                    )
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .contentShape(Rectangle())
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onEnded({ value in
                            
                            if -value.translation.width < (UIScreen.main.bounds.width / 2.5) && !content.showDeleteAlert{
                                content.showDeleteAlert = true
                            }
                            
                        }))
                        .alert("Sure to delete this content?", isPresented: $content.showDeleteAlert) {
                            
                            Button("Delete",role: .destructive) {
                                let index = postContent.firstIndex { currentPost in
                                    return currentPost.id == content.id
                                } ?? 0
                                
                                withAnimation {
                                    postContent.remove(at: index)
                                }
                            }
                        }
                    }
                    
                    Menu {
                        
                        ForEach(PostType.allCases,id: \.rawValue) { type in
                            
                            Button(type.rawValue) {
                                
                                withAnimation {
                                    postContent.append(PostContent(value: "", type: type))
                                }
                            }
                        }
                        
                    } label: {
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.primary)
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                }
                .padding()
            })
            .navigationTitle(postTitle == "" ? "Post Title" : postTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    if !showKeyboard {
                        Button("Cancel") {
                            blogData.createPost.toggle()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    if showKeyboard {
                        Button("Done") {
                            showKeyboard.toggle()
                        }
                    } else {
                        Button("Post") {
                            blogData.writePost(content: postContent,author: authorName,postTitle: postTitle)
                        }
                        .disabled(authorName == "" || postTitle == "")
                    }
                }
            }
        }
    }
}

struct CreatePost_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getFontSize(type: PostType)->CGFloat{
    switch type {
    case .Header:
        return 24
    case .SubHeading:
        return 22
    case .Paragraph:
        return 18
    case .Image:
        return 18
    }
}

struct WebImage: View{
    
    var url: String
    
    var body: some View{
        
        AsyncImage(url: URL(string: url)) { phase in
            
            if let image = phase.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                    .cornerRadius(15)
            } else {
                
                if let _ = phase.error {
                    Text("Failed to load Image :(((")
                } else {
                    ActivityIndicator()
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 44, height: 44)
                }
            }
        }
        .frame(height: 250)
        
    }
}

