//
//  Chat_BlogApp.swift
//  Chat Blog
//
//  Created by Livsy on 29.11.2022.
//

import SwiftUI

@main
struct Chat_BlogApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MainMessagesView()
                    .preferredColorScheme(.light)
                 .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Chat")
                  }
                
                BlogView(isShowPost: false)
                    .preferredColorScheme(.light)
                 .tabItem {
                    Image(systemName: "book.fill")
                    Text("Blog")
                  }
            }
            
           
        }
    }
}
