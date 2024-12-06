//
//  LoginViewModel.swift
//  onice
//
//  Created by Chaitali Sawant on 05/12/24.
//

import Foundation

class LoginViewModel {
    
    // Observable properties
    var isLoggedIn = false
    var errorMessage: String? = nil
    
    func login(username: String, password: String) async {
        do {
            // Perform login
            let token = try await NetworkManager.shared.login(username: username, password: password)
            
            // Save token to Keychain
            KeychainHelper.saveTokenToKeychain(token)
            
            // Set login state
            self.isLoggedIn = true
        } catch {
            // Handle error
            self.errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }
}
