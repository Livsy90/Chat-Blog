//
//  String+adds.swift
//  Chat Blog
//
//  Created by Livsy on 05.12.2022.
//

import UIKit

extension String {
    var base64Image: UIImage? {
        guard let imageData = Data(base64Encoded: self) else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
}
