//
//  BlogViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 06.12.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class BlogViewModel: ObservableObject {
    
    @Published var posts: [Post]?
    @Published var post: Post = .init(title: "", author: "", postContent: [])
    
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    @Published var createPost = false
    @Published var isWriting = false
    
    func fetchPosts() async {
        
        if posts != nil {
            return
        }
        
        do {
            
            let db = FirebaseManager.shared.firestore.collection("Blog")
            
            let posts = try await db.getDocuments()
            
            self.posts = posts.documents.compactMap { post in
                return try? post.data(as: Post.self)
            }
        }
        catch {
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deletePost(post: Post) {
        
        guard let _ = posts else { return }
        
        let index = posts?.firstIndex(where: { currentPost in
            return currentPost.id == post.id
        }) ?? 0
        
        FirebaseManager.shared.firestore.collection("Blog").document(post.id ?? "").delete()
        
        withAnimation {
            DispatchQueue.main.async {
                self.posts?.remove(at: index)
            }
        }
    }
    
    func writePost(content: [PostContent], author: String, postTitle: String) {
        
        do {
            
            withAnimation{
                isWriting = true
            }
            
            let post = Post(title: postTitle, author: author, postContent: content)
            
            let _ = try FirebaseManager.shared.firestore.collection("Blog").document().setData(from: post, completion: { err in
                if let _ = err{
                    return
                }
                
                withAnimation{ [self] in
                    posts?.append(post)
                    isWriting = false
                    createPost = false
                }
            })            
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
