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
    @Published var imageData: Data?

    @Published var errorMessage = ""
    
    func createAccountOrSignIn(success: @escaping () -> Void) {
        if isLoginMode {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { (res, err) in
                if let err = err {
                    print("Failed to login:", err)
                    self.errorMessage = err.localizedDescription
                    return
                }
                
                self.errorMessage = "User signed in: \(res?.user.uid ?? "")"
                success()
            }
        } else {
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { (res, err) in
                if let err = err {
                    print("Failed to create account:", err)
                    self.errorMessage = err.localizedDescription
                    return
                }
                
                self.errorMessage = "User created, saving profile image..."
                self.saveImageToStorage(success: success)
            }
        }
    }
    
    private func saveImageToStorage(success: @escaping () -> ()) {
        let filename = UUID().uuidString
        let ref = FirebaseManager.shared.storage.reference(withPath: filename)
        
        guard let imageData = imageData else {
            self.errorMessage = "No image selected"
            return
        }
        ref.putData(imageData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.errorMessage = "Failed saving image to storage: \(err.localizedDescription)"
                return
            }
            
            ref.downloadURL { (url, err) in
                if let err = err {
                    self.errorMessage = "Download url failure: \(err.localizedDescription)"
                    return
                }
                
                self.saveUserProfile(imageURLString: url?.absoluteString ?? "", success: success)
            }
        }
    }
    
    private func saveUserProfile(imageURLString: String, success: @escaping () -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["uid": uid, "email": email, "profileImageUrl": imageURLString]
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { (err) in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            
            self.errorMessage = "Ready to transition to main view"
            success()
        }
    }
}
