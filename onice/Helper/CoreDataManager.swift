//
//  CoreDataManager.swift
//  onice
//
//  Created by Chaitali Sawant on 05/12/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    // Save channels to Core Data
    func saveChannels(_ channels: [Channel]) {
        let fetchRequest: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        
        // Remove existing channels first if needed
        if let existingChannels = try? context.fetch(fetchRequest) {
            existingChannels.forEach { context.delete($0) }
        }
        
        // Save new channels
        channels.forEach { channel in
            let entity = ChannelEntity(context: context)
            entity.id = channel.id
            entity.name = channel.name
            entity.groupFolderName = channel.groupFolderName
        }
        
        try? self.context.save()
    }
    
    // Fetch channels from Core Data
    func fetchChannels() -> [Channel]? {
        let fetchRequest: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result?.map { Channel(id: $0.id!, name: $0.name!, groupFolderName: $0.groupFolderName!) }
    }
}
