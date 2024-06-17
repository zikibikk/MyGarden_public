//
//  TagRepository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 01.06.2024.
//

import UIKit
import CoreData

class TagRepository {
    
    public static let shared = TagRepository()
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
    
    public func createTag(tag: TagStruct) -> TagEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            guard let tagEntityDescription = NSEntityDescription.entity(forEntityName: "TagEntity", in: backgroundContext) else {
                print("Failed to create tagEntityDescription for \(tag) \(TagEntity.self)")
                return nil
            }
            
            let newTagEntity = TagEntity(entity: tagEntityDescription, insertInto: self.backgroundContext)
            newTagEntity.getInfo(tag: tag)
            
            do {
                try backgroundContext.save()
                print("Saved tag \(tag.name)!")
                return newTagEntity
            } catch {
                print("Failed to save background context: \(error)")
                return nil
            }
        }
    }
    
    public func fetchTags() -> [TagEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TagEntity.self)")
            
            do {
                let tags = try? backgroundContext.fetch(fetchRequest) as? [TagEntity]
                return tags ?? []
            }
        }
    }
    
    public func fetchTagWith(id: UUID) -> TagEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TagEntity.self)")
//            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            fetchRequest.predicate = predicate
            
            let fetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(TagEntity.self)", id: id)
            
            do {
                let tags = try? backgroundContext.fetch(fetchRequest) as? [TagEntity]
                return tags?.first
            }
        }
    }
    
    public func fetchTagWith(name: String) -> TagEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TagEntity.self)")
            let predicate = NSPredicate(format: "name == %@", name)
            fetchRequest.predicate = predicate
            
            do {
                let tags = try? backgroundContext.fetch(fetchRequest) as? [TagEntity]
                return tags?.first
            }
        }
    }
    
    public func deleteAllTags() {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TagEntity.self)")
            
            do {
                let tags = try? backgroundContext.fetch(fetchRequest) as? [TagEntity]
                tags?.forEach({backgroundContext.delete($0)})
                try? backgroundContext.save()
            }
        }
    }
}

//MARK: nsset extensions
extension TagRepository {
    
    private func fetchRequestWithIdPredicate(entityName: String, id: UUID) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        return fetchRequest
    }

    
    func add(noteWithID noteID: UUID, toTag tag: TagStruct) -> Bool {
        
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            let tagFetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(TagEntity.self)", id: tag.id)
            let noteFetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(NoteEntity.self)", id: noteID)
            
            do {
                let tags = try? backgroundContext.fetch(tagFetchRequest) as? [TagEntity]
                let notes = try? backgroundContext.fetch(noteFetchRequest) as? [NoteEntity]
                guard let noteToAdd = notes?.first else { return false }
                tags?.first?.addNote(note: noteToAdd)
                try? backgroundContext.save()
            }
            return true
        }
    }
    
    func add(plantWithID plantID: UUID, toTag tag: TagStruct) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            
            let tagFetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(TagEntity.self)", id: tag.id)
            let plantFetchRequest = self.fetchRequestWithIdPredicate(entityName: "\(PlantEntity.self)", id: plantID)
            
            
            do {
                let tags = try? backgroundContext.fetch(tagFetchRequest) as? [TagEntity]
                let plants = try? backgroundContext.fetch(plantFetchRequest) as? [PlantEntity]
                guard let plantToAdd = plants?.first else { return false }
                tags?.first?.addPlant(plant: plantToAdd)
                try? backgroundContext.save()
            }
            return true
        }
    }

    public func fethTagNotes(tag: TagStruct) -> [NoteEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            
            let tagRequest = self.fetchRequestWithIdPredicate(entityName: "\(TagEntity.self)", id: tag.id)
            
            do {
                let tags = try? backgroundContext.fetch(tagRequest) as? [TagEntity]
                let noteSet = tags?.first?.notes
                
                if let noteArray = noteSet?.allObjects as? [NoteEntity] {
                    return noteArray
                } else { return [] }
            }
        }
    }
    
    public func fethTagPlants(tag: TagStruct) -> [PlantEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            
            let tagRequest = self.fetchRequestWithIdPredicate(entityName: "\(TagEntity.self)", id: tag.id)
            
            do {
                let tags = try? backgroundContext.fetch(tagRequest) as? [TagEntity]
                let plantSet = tags?.first?.plants
                
                if let plantArray = plantSet?.allObjects as? [PlantEntity] {
                    return plantArray
                } else { return [] }
            }
        }
    }
    
    func remove(fromNote: NoteStruct, tag: TagStruct) {
        guard let backgroundContext = self.backgroundContext else { return }
        
        var repository = Repository<TagEntity>()
        repository.manipulateEntityToEntity(addStruct: fromNote.id, toStruct: tag.id, add: NoteEntity.self, to: TagEntity.self, backContext: backgroundContext) { manipulating, target in
            target.removeNote(note: manipulating)
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


