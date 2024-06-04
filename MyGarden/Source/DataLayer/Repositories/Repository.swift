//
//  Repository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 02.06.2024.
//

import UIKit
import CoreData

public protocol EntityWithManagedSet: NSManagedObject {
    var id: UUID { get  }
}

protocol iStr {
    var id: UUID { get set }
}


class Repository<MainEntity: EntityWithManagedSet> {
    
    func fetchRequestWithIdPredicate<Entity: NSManagedObject>(entity: Entity.Type, id: UUID) -> NSFetchRequest<Entity> {
        let addingFetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        let addingPredicate = NSPredicate(format: "id == %@", id as CVarArg)
        addingFetchRequest.predicate = addingPredicate
        
        return addingFetchRequest
    }
    
    func fetchAll(backContext: NSManagedObjectContext) -> [MainEntity] {
        
        return backContext.performAndWait {
            let fetchRequest = NSFetchRequest<MainEntity>(entityName: String(describing: MainEntity.self))
            
            do {
                let entities = try? backContext.fetch(fetchRequest)
                return entities ?? []
            }
        }
    }
    
    func fetchWithID<Entity: NSManagedObject>(entity: Entity.Type, id: UUID, backgroundContext: NSManagedObjectContext) -> Entity? {
        
        return backgroundContext.performAndWait {
            
            let fetchRequest = self.fetchRequestWithIdPredicate(entity: Entity.self, id: id)
            
            do {
                let entities = try? backgroundContext.fetch(fetchRequest)
                return entities?.first
            }
        }
    }
    
    func deleteAll(backgroundContext: NSManagedObjectContext) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<MainEntity>(entityName: String(describing: MainEntity.self))
            
            do {
                let entities = try? backgroundContext.fetch(fetchRequest)
                entities?.forEach({backgroundContext.delete($0)})
                try? backgroundContext.save()
            }
        }
    }
    
    func deleteWithID<Entity: NSManagedObject>(entity: Entity.Type, id: UUID, backgroundContext: NSManagedObjectContext) -> Bool {
        
        guard let entityToDelete = fetchWithID(entity: entity, id: id, backgroundContext: backgroundContext) else { return false }
        
        do {
            backgroundContext.delete(entityToDelete)
            try backgroundContext.save()
            return true
        } catch {
            print("Failed to dalete background context: \(error)")
            return false
        }
    }
    
    func manipulateEntityToEntity<Add: NSManagedObject>(
        addStruct: UUID,
        toStruct: UUID,
        add: Add.Type,
        to: MainEntity.Type,
        backContext: NSManagedObjectContext,
        manipulation: @escaping(_ manipulating: Add, _ target: MainEntity) -> ()) {
        
        backContext.performAndWait {
            
            let addingFetchRequest = self.fetchRequestWithIdPredicate(entity: Add.self, id: addStruct)
            
            let targetFetchRequest = self.fetchRequestWithIdPredicate(entity: MainEntity.self, id: toStruct)
            
            do {
                let targets = try? backContext.fetch(targetFetchRequest)
                let addings = try? backContext.fetch(addingFetchRequest)
                guard let addingEntity = addings?.first else { return }
                guard let targetEntity = targets?.first else { return }
                manipulation(addingEntity, targetEntity)
                try? backContext.save()
            }
        }
    }
    
}
