//
//  APIManager.swift
//
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation
import Combine

public protocol APIManagerProtocol {
    func get<T: Decodable>(path: String) -> AnyPublisher<T, Error>
    func post<R: Decodable>(path: String) -> AnyPublisher<R, Error>
    func post<T: Encodable, R: Decodable>(path: String, body: T) -> AnyPublisher<R, Error>
    func upload(path: String, fileData: Data, fileName: String, mimeType: String, parameterName: String) -> AnyPublisher<Data, Error>
    
    func setToken(_ token: String)
    func getToken() -> String
}

public class APIManager: APIManagerProtocol {
    
    private var _baseURL: String
    private var token = ""
    
    /// Initialization
    public init(baseURL: String, serviceName: String) {
        _baseURL = baseURL
        
        Task {
            token = await KeychainStorage(serviceName: serviceName).getString(with: "token") ?? ""
        }
    }
    
    /// Token
    public func getToken() -> String {
        return token
    }
    
    public func setToken(_ token: String) {
        self.token = token
    }

    /// Methods
    public func get<T: Decodable>(path: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: _baseURL + path) else {
            return Fail(error: CustomError.networkError(type: .invalidURL)).eraseToAnyPublisher()
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(HTTPHeader.json.rawValue,
                         forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if !token.isEmpty {
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.backendFormat)
        
        return session.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw CustomError.networkError(type: .invalidResponse)
                }
                
                let statusCode = httpResponse.statusCode
                let httpStatus = HTTPResponse(statusCode: statusCode)
                
                guard httpResponse.statusCode == 200 else {
                    throw CustomError.networkError(type: .invalidStatusCode(httpResponse.statusCode, httpStatus))
                }
                
                return data
            }
            .mapError { error -> Error in
                return error
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    public func post<R>(path: String) -> AnyPublisher<R, Error> where R : Decodable {
        guard let url = URL(string: _baseURL + path) else {
            return Fail(error: CustomError.networkError(type: .invalidURL)).eraseToAnyPublisher()
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeader.json.rawValue,
                         forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if !token.isEmpty {
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.backendFormat)

        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw CustomError.networkError(type: .invalidResponse)
                }
                
                let statusCode = httpResponse.statusCode
                let httpStatus = HTTPResponse(statusCode: statusCode)
                
                guard httpResponse.statusCode == 200 else {
                    throw CustomError.networkError(type: .invalidStatusCode(httpResponse.statusCode, httpStatus))
                }
                
                return data
            }
            .mapError { error -> Error in
                return error
            }
            .decode(type: R.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    public func post<T: Encodable, R: Decodable>(path: String, body: T) -> AnyPublisher<R, Error> {
        guard let url = URL(string: _baseURL + path) else {
            return Fail(error: CustomError.networkError(type: .invalidURL)).eraseToAnyPublisher()
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(HTTPHeader.json.rawValue,
                         forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if !token.isEmpty {
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.backendFormat)
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            return Fail(error: CustomError.networkError(type: .invalidResponse)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw CustomError.networkError(type: .invalidResponse)
                }
                
                let statusCode = httpResponse.statusCode
                let httpStatus = HTTPResponse(statusCode: statusCode)
                
                guard httpResponse.statusCode == 200 else {
                    throw CustomError.networkError(type: .invalidStatusCode(httpResponse.statusCode, httpStatus))
                }
                
                return data
            }
            .mapError { error -> Error in
                return error
            }
            .decode(type: R.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    public func upload(path: String, fileData: Data, fileName: String, mimeType: String, parameterName: String = "file") -> AnyPublisher<Data, Error> {
        guard let url = URL(string: _baseURL + path) else {
            return Fail(error: CustomError.networkError(type: .invalidURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }

        var body = Data()

        // File data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(parameterName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)

        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let session = URLSession(configuration: .default)

        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw CustomError.networkError(type: .invalidResponse)
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw CustomError.networkError(type: .invalidStatusCode(httpResponse.statusCode, HTTPResponse(statusCode: httpResponse.statusCode)))
                }
                
                return data
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }

}
