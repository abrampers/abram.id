//
//  DateFormatter.swift
//  
//
//  Created by Abram Situmorang on 08/03/20.
//

import Foundation

extension DateFormatter {
    static var article: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
