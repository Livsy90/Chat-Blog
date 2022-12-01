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
            MainMessagesView()
                .preferredColorScheme(.light)
        }
    }
}
