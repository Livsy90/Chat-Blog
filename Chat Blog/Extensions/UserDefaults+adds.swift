//
//  UserDefaults+adds.swift
//  Chat Blog
//
//  Created by Livsy on 05.12.2022.
//

import Foundation

enum UDAliases: String {
     case lastReadInfo
}

extension UserDefaults {
    @UserDefault(key: UDAliases.lastReadInfo.rawValue, defaultValue: [:])
    static var lastReadInfo: [String: String] // [userId: messageId]
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
