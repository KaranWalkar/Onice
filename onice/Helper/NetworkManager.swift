//
//  NetworkManager.swift
//  onice
//
//  Created by Chaitali Sawant on 05/12/24.
//

import Foundation

// Define the response structure expected from the login API
struct LoginResponse: Codable {
    let token: String
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // Login API request
    func login(username: String, password: String) async throws -> String {
        let url = URL(string: "https://mail.icewarp.com/teamchatapi/iwauthentication.login.plain")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("mofa.onice.io", forHTTPHeaderField: "Host")
        
        // Encode the parameters in the body
        let body = "username=\(username)&password=\(password)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        }
        // Handle the response data if needed
        do {
            // Parse the response data (assuming JSON response here)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Response: \(json)")
            }
        } catch {
            print("Failed to parse JSON: \(error.localizedDescription)")
        }
//        if let httpResponse = response as? HTTPURLResponse {
//            print("HTTP Status Code: \(httpResponse.statusCode)")
//        }
        
        // Decode the response into LoginResponse
        let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        return decodedResponse.token
    }
    
    // Fetch channels API request
    func fetchChannels(token: String) async throws -> [Channel] {
        let url = URL(string: "https://mail.icewarp.com/teamchatapi/channels.list")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body
        let body = "token=\(token)&include_unread_count=true&exclude_members=true"
        request.httpBody = body.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the channels response
        let channels = try JSONDecoder().decode([Channel].self, from: data)
        return channels
    }
}
