//
//  NoteRepository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 11.05.2024.
//

import UIKit
import CoreData

public final class NoteRepository: iNoteRepository {
    public static let shared = NoteRepository()
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
    
    public func createNote(note: NoteStruct) {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "NoteEntity", in: backgroundContext) else {
                print("Failed to create noteEntityDescription for \(note) \(NoteEntity.self)")
                return
            }
            
            let newNoteEntity = NoteEntity(entity: noteEntityDescription, insertInto: self.backgroundContext)
            
            newNoteEntity.getInfo(note: note)
            
            do {
                try backgroundContext.save()
                print("Saved!")
            } catch {
                print("Failed to save background context: \(error)")
            }
        }
    }
    
    public func fetchNotes() -> [NoteEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
            
            do {
                let notes = try? backgroundContext.fetch(fetchRequest) as? [NoteEntity]
                return notes ?? []
            }
        }
    }
    
    public func fetchNote(with date: Date) -> NoteEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
            let predicate = NSPredicate(format: "date == %@", date as NSDate)
            fetchRequest.predicate = predicate
            
            do {
                let notes = try? backgroundContext.fetch(fetchRequest) as? [NoteEntity]
                return notes?.first
            }
        }
    }
    
    public func updateNote(with date: Date, newText: String) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        guard let note = fetchNote(with: date) else { return false }
        note.text = newText

        return backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                print("Updated")
                return true
            } catch {
                print("Failed to update background context: \(error)")
                return false
            }
        }
    }
    
    public func deleteAllNotes() {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
            
            do {
                let notes = try? backgroundContext.fetch(fetchRequest) as? [NoteEntity]
                notes?.forEach({backgroundContext.delete($0)})
                try? backgroundContext.save()
            }
        }
    }
    
    public func deleteNote(with date: Date) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            guard let noteToDelete = fetchNote(with: date) else { return false }
            backgroundContext.delete(noteToDelete)
            do {
                try backgroundContext.save()
                print("Deleted")
                return true
            } catch {
                print("Failed to dalete background context: \(error)")
                return false
            }
        }
    }
}

//MARK: nsset operations
extension NoteRepository {
    public func fethNoteTags(note: NoteStruct) -> [TagEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            let fetchNoteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
            let predicateNote = NSPredicate(format: "id == %@", note.id as CVarArg)
            fetchNoteRequest.predicate = predicateNote
            
            do {
                let notes = try? backgroundContext.fetch(fetchNoteRequest) as? [NoteEntity]
                let tagSet = notes?.first?.tags
                
                if let tagArray = tagSet?.allObjects as? [TagEntity] {
                    return tagArray
                } else { return [] }
            }
        }
    }
    
    public func addTagToNote(_ tag: TagStruct, toNote note: NoteStruct) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            let fetchNoteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
            let predicateNote = NSPredicate(format: "id == %@", note.id as CVarArg)
            fetchNoteRequest.predicate = predicateNote
            let fetchTagRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TagEntity.self)")
            let predicateTag = NSPredicate(format: "id == %@", tag.id as CVarArg)
            fetchTagRequest.predicate = predicateTag
            
            
            do {
                let notes = try? backgroundContext.fetch(fetchNoteRequest) as? [NoteEntity]
                let tags = try? backgroundContext.fetch(fetchTagRequest) as? [TagEntity]
                guard let tagToAdd = tags?.first else { return false }
                notes?.first?.addTag(tag: tagToAdd)
                try? backgroundContext.save()
            }
            return true
        }
    }
    
    public func removeTagFromNote(_ tag: TagStruct, fromNote note: NoteStruct) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            let fetchNoteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
            let predicateNote = NSPredicate(format: "id == %@", note.id as CVarArg)
            fetchNoteRequest.predicate = predicateNote
            let fetchTagRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TagEntity.self)")
            let predicateTag = NSPredicate(format: "id == %@", tag.id as CVarArg)
            fetchTagRequest.predicate = predicateTag
            
            
            do {
                let notes = try? backgroundContext.fetch(fetchNoteRequest) as? [NoteEntity]
                let tags = try? backgroundContext.fetch(fetchTagRequest) as? [TagEntity]
                guard let tagToDelete = tags?.first else { return false }
                notes?.first?.removeTag(tag: tagToDelete)
                backgroundContext.delete(tagToDelete)
                try? backgroundContext.save()
            }
            return true
        }
    }
}
