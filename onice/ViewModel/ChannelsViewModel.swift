//
//  ChannelsViewModel.swift
//  onice
//
//  Created by Chaitali Sawant on 05/12/24.
//

import Foundation

class ChannelsViewModel {
    
    var channels: [Channel] = []
    var errorMessage: String?
    
    func loadChannels() async {
        guard let token = KeychainHelper.getTokenFromKeychain() else {
            self.errorMessage = "User not logged in."
            return
        }
        
        do {
            let fetchedChannels = try await NetworkManager.shared.fetchChannels(token: token)
            self.channels = fetchedChannels
            // Save channels to Core Data
            CoreDataManager.shared.saveChannels(fetchedChannels)
        } catch {
            // Try loading offline data if API fails
            if let offlineChannels = CoreDataManager.shared.fetchChannels() {
                self.channels = offlineChannels
            } else {
                self.errorMessage = "Failed to load channels."
            }
        }
    }
}
