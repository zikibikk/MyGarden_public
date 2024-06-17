//
//  PlantService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 31.05.2024.
//

import UIKit
import CoreData

class PlantService {
    let repository: PlantRepository
    
    static var shared = PlantService(repository: PlantRepository.shared)
    
    private init(repository: PlantRepository) {
        self.repository = repository
    }
    
    func savePlant(withName plant: String) -> PlantStruct? {
        guard let plant = repository.createPlant(withName: plant) else {return nil}
        return .init(entity: plant)
    }
    
    func savePlant(plant: PlantStruct) {
        repository.createPlant(plant: plant)
    }
    
    func getAllPlants() -> [PlantStruct] {
        return repository.fetchPlants().map { plantEntity in
                return PlantStruct(entity: plantEntity)
        }
    }
    
    func get(plantWithID id: UUID) -> PlantStruct? {
        guard let plant = repository.fetchPlantWith(id: id) else { return nil }
        return .init(entity: plant)
    }
    
    func add(reminder: ReminderStruct, toPlant plant: PlantStruct) {
        repository.addReminderToPlant(reminder, toPlant: plant)
    }
    
    func remove(reminder: ReminderStruct, fromPlant plant: PlantStruct) {
        repository.removeReminderFromPlant(reminder, fromPlant: plant)
    }
    
    func add(tag: TagStruct, toPlant plant: PlantStruct) {
        repository.add(tag: tag, toPlant: plant)
    }
    
    func remove(tag: TagStruct, fromPlant plant: PlantStruct) {
        repository.remove(fromPlant: plant, tag: tag)
    }
    
    func deleteAllPlants() {
        repository.deleteAllPlants()
    }
    
    func getPlantReminders(plant: PlantStruct) -> [ReminderStruct] {
        return repository.fethPlantReminders(plant: plant)
            .sorted(by: {$0.dateWithTime < $1.dateWithTime}).map({.init(entity: $0)})
    }
    
    func getPlantRemindersForToday(plant: PlantStruct) -> [ReminderStruct] {
        return ReminderService.shared.getRemindersForDate(date: Date()).filter({$0.reminderPlant == plant.id})
    }
    
    func getTags(forPlant plant: PlantStruct) -> [TagStruct] {
        return repository.fetchTags(forPlant: plant).map({.init(entity: $0)})
    }
    
    
    func test() {
        
        print("plants are \(getAllPlants().count) plants")
        
        let testPlant = getAllPlants()[1]
        
        
        
//        print("plants are \(getAllPlants()[0].name) \(getAllPlants()[0].reminders.count) \(getPlantReminders(plant: getAllPlants()[0])) r")
        
    }
}
