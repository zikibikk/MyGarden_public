//
//  ReminderEntity.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 27.05.2024.
//

import CoreData

@objc(ReminderEntity)
public class ReminderEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var dateWithTime: Date
    @NSManaged public var plant: PlantEntity?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
    
    @objc(addPlant:)
    func addPlant(plant: PlantEntity) {
        self.plant = plant
    }
}

extension ReminderEntity: Identifiable {}


public struct ReminderStruct {
    let id: UUID
    let reminderText: String
    let reminderTime: String
    let reminderDate: String
    let reminderDateWithTime: Date
    let reminderPlant: UUID?
    
    init(id: UUID, reminderText: String, reminderTime: String, reminderDate: String, reminderDateWithTime: Date, reminderPlant: UUID? = nil) {
        self.id = id
        self.reminderText = reminderText
        self.reminderTime = reminderTime
        self.reminderDate = reminderDate
        self.reminderDateWithTime = reminderDateWithTime
        self.reminderPlant = reminderPlant
    }
    
    init(entity: ReminderEntity) {
        var plant: UUID? = nil
        if let plantEntity = entity.plant {
            plant = plantEntity.id
        }
        
        self.init(id: entity.id, reminderText: entity.text, reminderTime: entity.dateWithTime.getTime(), reminderDate: entity.date.getDayWithMonthString(), reminderDateWithTime: entity.dateWithTime, reminderPlant: plant)
    }
}
