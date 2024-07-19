//
//  PortfolioDataService.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 17/07/2024.
//

import Foundation
import CoreData


class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PorfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container =  NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error =  error {
                print("Error loading core data. \(error)")
            }
            self.getPorfolio()
        }
    }
    
    //    MARK: PUBLIC
    func updatePortfio(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id
        }) {
            
            print("Updating coin: \(coin.name) with amount: \(amount)")
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    
//    MARK: PRIVATE
    
    private func getPorfolio() {
        print("Getting portfolio")
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
          savedEntities =  try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio Entities. \(error)")
        }
        
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
        applyChanges()
      
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
   private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save() {
        print("Saving to core data")
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to core data. \(error)")
        }
    }
    
    
    private func applyChanges() {
        save()
        getPorfolio()
    }
 }
