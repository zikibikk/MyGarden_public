//
//  Repository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 02.06.2024.
//

import UIKit
import CoreData

public protocol EntityWithID: NSManagedObject {
    var id: UUID { get  }
}

public protocol DataTransferModel {
    var id: UUID { get set }
}


class Repository<MainEntity: EntityWithID> {
    
    func create( entitySetUp closure: @escaping(_ entity: MainEntity) -> (), backgroundContext: NSManagedObjectContext) -> MainEntity? {
        return backgroundContext.performAndWait {
            guard let mainEntityDescription = NSEntityDescription.entity(forEntityName: "\(MainEntity.self)", in: backgroundContext) else {
                print("Failed to create noteEntityDescription for \(NoteEntity.self)")
                return nil
            }
            
            let entityToSave = MainEntity(entity: mainEntityDescription, insertInto: backgroundContext) as! MainEntity
            closure(entityToSave)
            
            do {
                try backgroundContext.save()
                print("Saved!")
            } catch {
                print("Failed to save background context: \(error)")
                return nil
            }
            
            return entityToSave
        }
    }
    
    
    func fetchRequestWithIdPredicate<Entity: NSManagedObject>(entity: Entity.Type, id: UUID) -> NSFetchRequest<Entity> {
        let addingFetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        let addingPredicate = NSPredicate(format: "id == %@", id as CVarArg)
        addingFetchRequest.predicate = addingPredicate
        
        return addingFetchRequest
    }
    
    func fetchRequestWithPredicate(predicate: String, argument: CVarArg) -> NSFetchRequest<MainEntity> {
        let addingFetchRequest = NSFetchRequest<MainEntity>(entityName: String(describing: MainEntity.self))
        let addingPredicate = NSPredicate(format: "\(predicate) == %@", argument)
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
    
    func fetch<Entity: NSManagedObject>(withID id: UUID, EntityOfType: Entity.Type, backgroundContext: NSManagedObjectContext) -> Entity? {
        
        return backgroundContext.performAndWait {
            
            let fetchRequest = self.fetchRequestWithIdPredicate(entity: Entity.self, id: id)
            
            do {
                let entities = try? backgroundContext.fetch(fetchRequest)
                return entities?.first
            }
        }
    }
    
    func fetchWith(predicate: String, value: CVarArg, backgroundContext: NSManagedObjectContext) -> MainEntity? {
        return backgroundContext.performAndWait {
            let fetchRequest = self.fetchRequestWithPredicate(predicate: predicate, argument: value)
            
            do {
                let entities = try? backgroundContext.fetch(fetchRequest)
                return entities?.first as? MainEntity
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
    
    func delete<Entity: NSManagedObject>(withID id: UUID, EntityOfType : Entity.Type,backgroundContext: NSManagedObjectContext) -> Bool {
        
        guard let entityToDelete = fetch(withID: id, EntityOfType: Entity.self, backgroundContext: backgroundContext) else { return false }
        
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
    
    func fetch<FetchingEntity>(fromEntityWithID id: UUID, arrayOfType: FetchingEntity.Type, fromSet closure: @escaping(_ fromEntity: MainEntity?) -> NSSet?, backgroundContext: NSManagedObjectContext) -> [FetchingEntity] {
        return backgroundContext.performAndWait {
            let mainEntityRequest = self.fetchRequestWithIdPredicate(entity: MainEntity.self, id: id)
            
            do {
                let mains = try? backgroundContext.fetch(mainEntityRequest)
                let set = closure(mains?.first)
                
                if let fetchingEntityArray = set?.allObjects as? [FetchingEntity] {
                    return fetchingEntityArray
                } else { return [] }
            }
        }
    }
    
}
