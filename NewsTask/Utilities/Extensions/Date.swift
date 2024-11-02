//
//  Date.swift
//  NewsTask
//
//  Created by Azoz Salah on 01/11/2024.
//

import Foundation

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: self)
        
        return formattedDate
    }
}
