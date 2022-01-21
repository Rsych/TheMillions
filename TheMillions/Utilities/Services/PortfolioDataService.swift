//
//  PortfolioDataService.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/21.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentCloudKitContainer
    private let containerName: String = "Portfolio"
    private let entityName: String = "Portfolio"
    
    @Published var savedEntities: [Portfolio] = []
    
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: containerName, managedObjectModel: Self.model)
        
        // For testing purposes, creates /dev/null which is destroyed when app is finished.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.net.naolin.TheMillions"
            
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Portfolio.sqlite")
            }
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            // Automatically merge changes from iCloud
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            // Load Portfolio after merge iCloud
            self.getPortfolio()
        }
    }
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Portfolio", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        
        return managedObjectModel
    }()
    
    func updatePortfolio(coin: Coin, amount: Double) {
        // check if coin is already in Portfolio
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error.localizedDescription)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.id = coin.id
        entity.amount = amount
        applyChanges()
    }
    private func update(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
        // iCloud
        uploadToiCloud(entity)
    }
    private func delete(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
        // iCloud
        removeFromCloud(entity)
    }
    
    //    private func save() {
    //        do {
    //            try container.viewContext.save()
    //        } catch let error {
    //            print("Error saving to Core Data. \(error.localizedDescription)")
    //        }
    //    }
    private func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving to Core Data. \(error.localizedDescription)")
            }
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
