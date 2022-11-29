//
//  LoginViewModel.swift
//  Chat Blog
//
//  Created by Livsy on 29.11.2022.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoginMode = false
    @Published var selectedImage: Image?
}
