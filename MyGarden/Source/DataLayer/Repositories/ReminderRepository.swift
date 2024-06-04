//
//  ReminderRepository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 27.05.2024.
//

import UIKit
import CoreData

public final class ReminderRepository {
    
    public static let shared = ReminderRepository()
    
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
    
    public func createReminder(dateWithoutTime: Date, dateWithTime: Date, text: String) -> ReminderEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        var result: ReminderEntity? = nil
        
        backgroundContext.performAndWait {
            guard let reminderEntityDescription = NSEntityDescription.entity(forEntityName: "ReminderEntity", in: backgroundContext) else {
                print("Failed to create reminderEntityDescription for \(text) \(ReminderEntity.self)")
                return
            }
            let newReminderEntity = ReminderEntity(entity: reminderEntityDescription, insertInto: self.backgroundContext)
            newReminderEntity.date = dateWithoutTime
            newReminderEntity.dateWithTime = dateWithTime
            newReminderEntity.text = text
            
            result = newReminderEntity
            do {
                try backgroundContext.save()
                print("reminder saved!")
            } catch {
                print("Failed to save background context: \(error)")
            }
        }
        
        return result
    }
    
    public func fetchAllReminders() -> [ReminderEntity] {
        guard let backgroundContext = self.backgroundContext else { return [] }
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(ReminderEntity.self)")
            do {
                let reminders = try? backgroundContext.fetch(fetchRequest) as? [ReminderEntity]
                return reminders ?? []
            }
        }
    }
    
    public func fetchReminders(withDateWithoutTime date: Date) -> [ReminderEntity]? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(ReminderEntity.self)")
            let predicate = NSPredicate(format: "date == %@", date as NSDate)
            fetchRequest.predicate = predicate
            
            do {
                let reminders = try? backgroundContext.fetch(fetchRequest) as? [ReminderEntity]
                return reminders
            }
        }
    }
    
    public func fetchReminder(withFullDate dateWithTime: Date) -> ReminderEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(ReminderEntity.self)")
            let predicate = NSPredicate(format: "dateWithTime == %@", dateWithTime as NSDate)
            fetchRequest.predicate = predicate
            
            do {
                let reminders = try? backgroundContext.fetch(fetchRequest) as? [ReminderEntity]
                return reminders?.first
            }
        }
    }
    
    public func fetchReminder(withID id: UUID) -> ReminderEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(ReminderEntity.self)")
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            fetchRequest.predicate = predicate
            
            do {
                let reminders = try? backgroundContext.fetch(fetchRequest) as? [ReminderEntity]
                return reminders?.first
            }
        }
    }
    
    public func deleteAllReminders() {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(ReminderEntity.self)")
            
            do {
                let reminders = try? backgroundContext.fetch(fetchRequest) as? [ReminderEntity]
                reminders?.forEach({backgroundContext.delete($0)})
                try? backgroundContext.save()
            }
        }
    }
    
    public func deleteReminder(withFullDate date: Date) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            guard let reminderToDelete = fetchReminder(withFullDate: date) else { return false }
            backgroundContext.delete(reminderToDelete)
            do {
                try backgroundContext.save()
                print("Deleted reminder with date \(date)")
                return true
            } catch {
                print("Failed to dalete background context: \(error)")
                return false
            }
        }
    }
    
    public func deleteReminder(withId id: UUID) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            guard let reminderToDelete = fetchReminder(withID: id) else { return false }
            backgroundContext.delete(reminderToDelete)
            do {
                try backgroundContext.save()
                print("Deleted reminder with id \(id.description)")
                return true
            } catch {
                print("Failed to dalete background context: \(error)")
                return false
            }
        }
    }
}

