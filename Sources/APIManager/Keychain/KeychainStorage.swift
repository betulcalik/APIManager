//
//  File.swift
//  
//
//  Created by Betül Çalık on 22.03.2024.
//

import Foundation
import KeychainAccess

final class KeychainStorage {
    
    private let keychain: Keychain
    
    public init(serviceName: String) {
        self.keychain = Keychain(service: serviceName)
    }
    
    func save(data: String, with key: String) async {
        do {
            try keychain.set(data, key: key)
        } catch {
            debugPrint("Error: ", error)
        }
    }

    func save(data: Data, with key: String) async {
        do {
            try keychain.set(data, key: key)
        } catch {
            debugPrint("Error: ", error)
        }
    }
    
    func getString(with key: String) async -> String? {
        do {
            return try keychain.getString(key)
        } catch {
            debugPrint("Error: ", error)
        }
        
        return nil
    }
    
    func getData(with key: String) async -> Data? {
        do {
            return try keychain.getData(key)
        } catch {
            debugPrint("Error: ", error)
        }
        
        return nil
    }
    
    func remove(with key: String) async {
        do {
            try keychain.remove(key)
        } catch {
            debugPrint("Error: ", error)
        }
    }
    
    func removeAll() async {
        do {
            try keychain.removeAll()
        } catch {
            debugPrint("Error: ", error)
        }
    }
}
