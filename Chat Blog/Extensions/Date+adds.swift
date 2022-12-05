//
//  Date+adds.swift
//  Chat Blog
//
//  Created by Livsy on 05.12.2022.
//

import Foundation

extension Date {
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.locale = .current
        return dateFormatter.string(from: self)
    }
}
