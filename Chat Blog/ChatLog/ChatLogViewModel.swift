//
//  ChatLogViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 30.11.2022.
//

import SwiftUI

final class ChatLogViewModel: ObservableObject {
    @Published var text = ""
    
    func sendMessage() {
        print(text)
    }
}
