//
//  PlantRepository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 30.05.2024.
//

import UIKit
import CoreData

class PlantRepository {
    private let repository = Repository<PlantEntity>()
    
    public static let shared = PlantRepository()
    private init(){
        backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
    }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext?
    
    public func createPlant(withName plant: String) -> PlantEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            guard let plantEntityDescription = NSEntityDescription.entity(forEntityName: "PlantEntity", in: backgroundContext) else {
                print("Failed to create plantEntityDescription for \(plant) \(PlantEntity.self)")
                return nil
            }
            
            let newPlantEntity = PlantEntity(entity: plantEntityDescription, insertInto: self.backgroundContext)
            
            newPlantEntity.name = plant
            
            do {
                try backgroundContext.save()
                print("Saved plant \(plant)!")
                return newPlantEntity
            } catch {
                print("Failed to save background context: \(error)")
                return nil
            }
        }
    }
    
    public func createPlant(plant: PlantStruct) {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            guard let plantEntityDescription = NSEntityDescription.entity(forEntityName: "PlantEntity", in: backgroundContext) else {
                print("Failed to create plantEntityDescription for \(plant) \(PlantEntity.self)")
                return
            }
            
            let newPlantEntity = PlantEntity(entity: plantEntityDescription, insertInto: self.backgroundContext)
            newPlantEntity.getInfo(plant: plant)
            
            do {
                try backgroundContext.save()
                print("Saved plant \(plant.name)!")
            } catch {
                print("Failed to save background context: \(error)")
            }
        }
    }
    
    public func fetchPlants() -> [PlantEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(PlantEntity.self)")
            
            do {
                let plants = try? backgroundContext.fetch(fetchRequest) as? [PlantEntity]
                return plants ?? []
            }
        }
    }
    
    public func fetchPlantWith(id: UUID) -> PlantEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(PlantEntity.self)")
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            fetchRequest.predicate = predicate
            
            do {
                let plants = try? backgroundContext.fetch(fetchRequest) as? [PlantEntity]
                return plants?.first
            }
        }
    }
    
    public func fetchPlantWith(name: String) -> PlantEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(PlantEntity.self)")
            let predicate = NSPredicate(format: "name == %@", name)
            fetchRequest.predicate = predicate
            
            do {
                let plants = try? backgroundContext.fetch(fetchRequest) as? [PlantEntity]
                return plants?.first
            }
        }
    }
    
    public func deleteAllPlants() {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(PlantEntity.self)")
            
            do {
                let plants = try? backgroundContext.fetch(fetchRequest) as? [PlantEntity]
                plants?.forEach({backgroundContext.delete($0)})
                try? backgroundContext.save()
            }
        }
    }
    
}


//MARK: nsset operations
extension PlantRepository {
    
    func test(reminder: ReminderStruct, plant: PlantStruct) {
    }
    
    func fetchRequestWithIdPredicate(entityName: String, id: UUID) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    public func fethPlantReminders(plant: PlantStruct) -> [ReminderEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return repository.fetch(fromEntityWithID: plant.id, arrayOfType: ReminderEntity.self, fromSet: { fromEntity in
            fromEntity?.reminders
        }, backgroundContext: backgroundContext)
        
//        return backgroundContext.performAndWait {
//            
//            let plantRequest = self.fetchRequestWithIdPredicate(entityName: "\(PlantEntity.self)", id: plant.id)
//            
//            do {
//                let plants = try? backgroundContext.fetch(plantRequest) as? [PlantEntity]
//                let reminderSet = plants?.first?.reminders
//                
//                if let reminderArray = reminderSet?.allObjects as? [ReminderEntity] {
//                    return reminderArray
//                } else { return [] }
//            }
//        }
    }
    
    public func addReminderToPlant(_ reminder: ReminderStruct, toPlant plant: PlantStruct) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            
            let plantRequest = self.fetchRequestWithIdPredicate(entityName: "\(PlantEntity.self)", id: plant.id)
            let reminderRequest = self.fetchRequestWithIdPredicate(entityName: "\(ReminderEntity.self)", id: reminder.id)
            
            do {
                let plants = try? backgroundContext.fetch(plantRequest) as? [PlantEntity]
                let reminders = try? backgroundContext.fetch(reminderRequest) as? [ReminderEntity]
                guard let reminderToAdd = reminders?.first else { return false }
                plants?.first?.addReminder(reminder: reminderToAdd)
                try? backgroundContext.save()
            }
            return true
        }
    }
    
    public func removeReminderFromPlant(_ reminder: ReminderStruct, fromPlant plant: PlantStruct) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            
            let plantRequest = self.fetchRequestWithIdPredicate(entityName: "\(PlantEntity.self)", id: plant.id)
            let reminderRequest = self.fetchRequestWithIdPredicate(entityName: "\(ReminderEntity.self)", id: reminder.id)
            
            
            do {
                let plants = try? backgroundContext.fetch(plantRequest) as? [PlantEntity]
                let reminders = try? backgroundContext.fetch(reminderRequest) as? [ReminderEntity]
                guard let reminderToDelete = reminders?.first else { return false }
                plants?.first?.removeReminder(reminder: reminderToDelete)
                backgroundContext.delete(reminderToDelete)
                try? backgroundContext.save()
            }
            return true
        }
    }
    
    func fetchTags(forPlant plant: PlantStruct) -> [TagEntity]{
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            
            let plantRequest = self.fetchRequestWithIdPredicate(entityName: "\(PlantEntity.self)", id: plant.id)
            
            do {
                let plants = try? backgroundContext.fetch(plantRequest) as? [PlantEntity]
                let tagSet = plants?.first?.tags
                
                if let tagArray = tagSet?.allObjects as? [TagEntity] {
                    return tagArray
                } else { return [] }
            }
        }
    }
    
    func add(tag: TagStruct, toPlant plant: PlantStruct) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            let tagFetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(TagEntity.self)", id: tag.id)
            let plantFetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(PlantEntity.self)", id: plant.id)
            
            do {
                let tags = try? backgroundContext.fetch(tagFetchRequest) as? [TagEntity]
                let plants = try? backgroundContext.fetch(plantFetchRequest) as? [PlantEntity]
                guard let tagToAdd = tags?.first else { return false }
                plants?.first?.addTag(tag: tagToAdd)
                try? backgroundContext.save()
            }
            return true
        }
    }
    
    func remove(fromPlant: PlantStruct, tag: TagStruct) {
        guard let backgroundContext = self.backgroundContext else { return }
        
        var repository = Repository<TagEntity>()
        repository.manipulateEntityToEntity(addStruct: fromPlant.id, toStruct: tag.id, add: PlantEntity.self, to: TagEntity.self, backContext: backgroundContext) { manipulating, target in
            target.removePlant(plant: manipulating)
        }
    }
    
}

