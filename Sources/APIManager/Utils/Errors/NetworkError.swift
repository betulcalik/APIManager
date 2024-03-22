//
//  NetworkError.swift
//
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case invalidStatusCode(Int, HTTPResponse)
    case invalidURL
    
    var description: String {
        switch self {
        case .invalidResponse:
            return "Invalid response."
        case .invalidStatusCode(let code, let response):
            return "Invalid response code \(code): \(response)."
        case .invalidURL:
            return "Invalid URL."
        }
    }
}
