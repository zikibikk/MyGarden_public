//
//  PlantEntity.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 23.05.2024.
//

import CoreData
//TODO: хранить в растении зафиксированные напоминания, остальные будут тянуться по дате
@objc(PlantEntity)
public class PlantEntity: NSManagedObject, EntityWithID {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var notes: NSSet
    @NSManaged public var reminders: NSSet
    @NSManaged public var tags: NSSet
    @NSManaged public var photos: NSSet
    
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
    
    @objc(addNote:)
    func addNote(note: NoteEntity) {
        let notes = self.mutableSetValue(forKey: "notes")
        notes.add(note)
    }
    
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
    
    @objc(addTag:)
    func addTag(tag: TagEntity) {
        let tags = self.mutableSetValue(forKey: "tags")
        tags.add(tag)
    }
    
    @objc(removeTag:)
    func removeTag(tag: TagEntity) {
        let tags = self.mutableSetValue(forKey: "tags")
        tags.remove(tag)
    }
    
    @objc(addPhoto:)
    func addPhoto(photo: PhotoEntity) {
        let photos = self.mutableSetValue(forKey: "photos")
        photos.add(photo)
    }
    
    @objc(removePhoto:)
    func removePhoto(photo: PhotoEntity) {
        let photos = self.mutableSetValue(forKey: "photos")
        photos.remove(photo)
    }
    
}

struct PlantStruct {
    var id: UUID
    var name: String
    var notes: [NoteStruct] = []
    var reminders: [ReminderStruct] = []
    var tags: [TagStruct] = []
    var photos: [PhotoStruct] = []
    
    init(id: UUID, name: String, notes: [NoteStruct] = [], reminders: [ReminderStruct] = [], tags: [TagStruct] = [], photos: [PhotoStruct] = []) {
        self.id = id
        self.name = name
        self.notes = notes
        self.reminders = reminders
        self.tags = tags
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
        
        for tagEntity in entity.tags {
            self.tags.append(.init(entity: tagEntity as! TagEntity))
        }
        
        for photoEntity in entity.photos {
            self.photos.append(.init(entity: photoEntity as! PhotoEntity))
        }
    }
}
