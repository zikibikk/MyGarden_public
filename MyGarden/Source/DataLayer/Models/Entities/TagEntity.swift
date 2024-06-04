//
//  TagEntity.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 31.05.2024.
//

import UIKit
import CoreData

@objc(TagEntity)
public class TagEntity: NSManagedObject, EntityWithManagedSet {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var color: Data
    @NSManaged public var notes: NSSet
    @NSManaged public var plants: NSSet
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
    
    @objc(addNote:)
    func addNote(note: NoteEntity) {
        let notes = self.mutableSetValue(forKey: "notes")
        notes.add(note)
    }
    
    @objc(addPlant:)
    func addPlant(plant: PlantEntity) {
        let plants = self.mutableSetValue(forKey: "plants")
        plants.add(plant)
    }
    
    @objc(removeNote:)
    func removeNote(note: NoteEntity) {
        let notes = self.mutableSetValue(forKey: "notes")
        notes.remove(note)
    }
    
    @objc(removePlant:)
    func removePlant(plant: PlantEntity) {
        let plants = self.mutableSetValue(forKey: "plants")
        plants.remove(plant)
    }

    func getInfo(tag: TagStruct) {
        self.title = tag.name
        self.color = tag.color.encode() ?? Data()
    }
}

public struct TagStruct {
    let id: UUID
    let name: String
    let color: UIColor
    
    init(id: UUID = UUID(), name: String, color: UIColor) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    init(entity: TagEntity) {
        if let color = UIColor.decode(data: entity.color) {
            self.init(id: entity.id, name: entity.title, color: color)
        } else {
            self.init(id: entity.id, name: entity.title, color: .lightGreen)
        }
    }
}

