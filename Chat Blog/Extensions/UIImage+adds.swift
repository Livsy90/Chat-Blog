//
//  UIImage+adds.swift
//  Chat Blog
//
//  Created by Livsy on 05.12.2022.
//

import UIKit

extension UIImage {
    var base64String: String {
        jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
}
