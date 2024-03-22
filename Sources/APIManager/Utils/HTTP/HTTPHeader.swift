//
//  HTTPHeader.swift
//
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation

public enum HTTPHeader: String {
    case json = "application/json"
    case yaml = "application/yaml"
}

public enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}
