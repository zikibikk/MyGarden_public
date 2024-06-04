//
//  PlantEntity.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 23.05.2024.
//

import CoreData
//TODO: хранить в растении зафиксированные напоминания, остальные будут тянуться по дате
@objc(PlantEntity)
public class PlantEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var notes: NSSet
    @NSManaged public var reminders: NSSet
//    @NSManaged public var tags: NSSet?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
}

extension PlantEntity: Identifiable {}

extension PlantEntity {
    func getInfo(plant: PlantStruct) {
        self.name = plant.name
    }
    
//    @objc(addNote:)
//    func addNote(note: NoteEntity) {
//        let notes = self.mutableSetValue(forKey: "notes")
//        notes.add(note)
//    }
    
    @objc(addReminder:)
    func addReminder(reminder: ReminderEntity) {
        let reminders = self.mutableSetValue(forKey: "reminders")
        reminders.add(reminder)
    }
    
    @objc(removeReminder:)
    func removeReminder(reminder: ReminderEntity) {
        let reminders = self.mutableSetValue(forKey: "reminders")
        reminders.remove(reminder)
    }

}

struct PlantStruct {
    var id: UUID
    var name: String
    var notes: [NoteStruct] = []
    var reminders: [ReminderStruct] = []
    
    init(id: UUID, name: String, notes: [NoteStruct] = [], reminders: [ReminderStruct] = []) {
        self.id = id
        self.name = name
        self.notes = notes
        self.reminders = reminders
    }
    
    init(entity: PlantEntity) {
        self.id = entity.id
        self.name = entity.name
        
        let sortedRemindersEntities = entity.reminders.sorted(by: {($0 as! ReminderEntity).dateWithTime < ($1 as! ReminderEntity).dateWithTime})
        
        for noteEntity in entity.notes {
            self.notes.append(NoteStruct(entity: noteEntity as! NoteEntity))
        }
        
        for reminderEntity in sortedRemindersEntities {
            self.reminders.append(ReminderStruct(entity: reminderEntity as! ReminderEntity))
        }
    }
}
