//
//  FirebaseManager.swift
//  Chat Blog
//
//  Created by Livsy on 29.11.2022.
//

import Firebase
import FirebaseStorage

final class FirebaseManager: NSObject {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    override init() {
        FirebaseApp.configure()
        auth = Auth.auth()
        storage = Storage.storage()
        firestore = Firestore.firestore()
        super.init()
    }
}
