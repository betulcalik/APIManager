//
//  DateFormatter+Extensions.swift
//
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation

extension DateFormatter {
    
    static let backendFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
}
