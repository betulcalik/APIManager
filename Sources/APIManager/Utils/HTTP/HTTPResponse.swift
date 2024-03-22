//
//  HTTPResponse.swift
//
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation

public enum HTTPResponse {
    case informational(Int)
    case success(Int)
    case redirection(Int)
    case clientError(Int)
    case serverError(Int)
    case unknown(Int)
    
    init(statusCode: Int) {
        switch statusCode {
        case 100..<200:
            self = .informational(statusCode)
        case 200..<300:
            self = .success(statusCode)
        case 300..<400:
            self = .redirection(statusCode)
        case 400..<500:
            self = .clientError(statusCode)
        case 500..<600:
            self = .serverError(statusCode)
        default:
            self = .unknown(statusCode)
        }
    }
}
