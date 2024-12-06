//
//  KeychainHelper.swift
//  onice
//
//  Created by Chaitali Sawant on 05/12/24.
//

import Foundation
import Security

class KeychainHelper {
    
    // Save token to Keychain
    static func saveTokenToKeychain(_ token: String) {
        let keychainQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userToken",
            kSecValueData: token.data(using: .utf8)!
        ]
        
        // First delete any existing item
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new token
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    // Retrieve token from Keychain
    static func getTokenFromKeychain() -> String? {
        let keychainQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userToken",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(keychainQuery as CFDictionary, &item) == errSecSuccess,
           let data = item as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    // Delete token from Keychain (optional, can be used during logout)
    static func deleteTokenFromKeychain() {
        let keychainQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userToken"
        ]
        SecItemDelete(keychainQuery as CFDictionary)
    }
}
