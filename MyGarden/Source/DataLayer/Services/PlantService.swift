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
    
    func savePlant(plant: PlantStruct) {
        repository.createPlant(plant: plant)
    }
    
    func getAllPlants() -> [PlantStruct] {
        return repository.fetchPlants().map { plantEntity in
                return PlantStruct(entity: plantEntity)
        }
    }
    
    func add(reminder: ReminderStruct, toPlant plant: PlantStruct) {
        repository.addReminderToPlant(reminder, toPlant: plant)
    }
    
    func remove(reminder: ReminderStruct, fromPlant plant: PlantStruct) {
        repository.removeReminderFromPlant(reminder, fromPlant: plant)
    }
    
    func add(tag: TagStruct, toPlant plant: PlantStruct) {
        TagRepository.shared.add(plantWithID: plant.id, toTag: tag)
    }
    
    func remove(tag: TagStruct, fromPlant plant: PlantStruct) {
        TagRepository.shared.remove(fromPlant: plant, tag: tag)
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
    
    
    func test() {
        
        print("plants are \(getAllPlants().count) plants")
        
        let testPlant = getAllPlants()[1]
        
        
        
//        print("plants are \(getAllPlants()[0].name) \(getAllPlants()[0].reminders.count) \(getPlantReminders(plant: getAllPlants()[0])) r")
        
    }
}
