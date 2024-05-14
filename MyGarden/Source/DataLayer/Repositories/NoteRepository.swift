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
    private init(){}
    
    func test() {
        print("repo ww")
    }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createNote(id: Int16, note: NoteStruct) {
        guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "\(NoteEntity.self)", in: context) else {
            print("Не удалось создать noteEntityDescription для \(note)")
            return
        }
         
        let newNoteEntity = NoteEntity(entity: noteEntityDescription, insertInto: context)
        newNoteEntity.id = id
        newNoteEntity.getInfo(note: note)
        
        appDelegate.saveContext()
    }
    
    public func fetchNotes() -> [NoteEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
        do {
            return (try? context.fetch(fetchRequest) as? [NoteEntity]) ?? []
        }
    }
    
    public func fetchNote(with date: Date) -> NoteEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
        do {
            let notes = try? context.fetch(fetchRequest) as? [NoteEntity]
            return notes?.first(where: {$0.date == date})
        }
    }
    
    public func fetchNotePredicate(with date: Date) -> NoteEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
        fetchRequest.predicate = NSPredicate(format: "date == $@", date as CVarArg)
        do {
            let notes = try? context.fetch(fetchRequest) as? [NoteEntity]
            return notes?.first
        }
    }
    
    public func updateNote(with date: Date, newText: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
        do {
            guard let notes = try? context.fetch(fetchRequest) as? [NoteEntity],
                  let note = notes.first(where: {$0.date == date}) else { return }
            note.text = newText
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllNotes() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
        do {
            let notes = try? context.fetch(fetchRequest) as? [NoteEntity]
            notes?.forEach({context.delete($0)})
        }
        appDelegate.saveContext()
    }
    
    public func deleteNote(with date: Date) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(NoteEntity.self)")
        do {
            guard let notes = try? context.fetch(fetchRequest) as? [NoteEntity],
                  let noteToDelete = notes.first(where: {$0.date == date}) else { return }
            context.delete(noteToDelete)
        }
        appDelegate.saveContext()
    }
}
