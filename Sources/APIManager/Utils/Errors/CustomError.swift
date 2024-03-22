//
//  CustomError.swift
//  
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation

public enum CustomError: LocalizedError {
    case networkError(type: NetworkError)
    case cloudError(String)

    public var errorDescription: String? {
        switch self {
        case .networkError(let type):
            return type.description
        case .cloudError(let message):
            return message
        }
    }
}
