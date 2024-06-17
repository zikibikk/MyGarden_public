//
//  NoteCoreDataModel.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 11.05.2024.
//

import CoreData

@objc(NoteEntity)
public class NoteEntity: NSManagedObject, EntityWithID {
    
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var tags: NSSet
    @NSManaged public var plants: NSSet
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
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
    
    @objc(addPlant:)
    func addPlant(plant: PlantEntity) {
        let plants = self.mutableSetValue(forKey: "plants")
        plants.add(plant)
    }
    
    @objc(remove:)
    func remove(plant: PlantEntity) {
        let plants = self.mutableSetValue(forKey: "plants")
        plants.remove(plant)
    }
}

extension NoteEntity: Identifiable {}

extension NoteEntity {
    func getInfo(note: NoteStruct) {
        self.text = note.text
        self.date = note.date
    }
}

public struct NoteStruct {
    public var id: UUID
    var text: String
    var date: Date
//    var plants: [PlantStruct] = []
    
    init(id: UUID = UUID(), text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
    
    init(entity: NoteEntity) {
        id = entity.id
        text = entity.text
        date = entity.date
    }
}
