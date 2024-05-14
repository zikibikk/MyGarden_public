//
//  PlantasPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 08.05.2024.
//

import Foundation

class MockListOfPlantPresenter: iListOfPlantsPresenter {
    
    var listViewInput: iListOfPlantsView?
    
    func viewDidLoad() {
        listViewInput?.getListOfPlants(plantsNames: ["Кабачок", "Клубника", "Томат", "Виноград", "Роза"])
    }
    
    
    func selectedPlant(plant: String) {
        let plantPresenter = MockPlantPresenter(plant: plant)
        
        let plantViewController = PlantTableViewController(presenter: plantPresenter)
        plantPresenter.viewInput = plantViewController
        
        listViewInput?.navigationController?.pushViewController(plantViewController, animated: true)
    }
}

class MockPlantPresenter: iPlantPresenter {
    var plant: String
    weak var viewInput: iPlantView?
    
    required init(plant: String) {
        self.plant = plant
    }
    
    func viewDidLoad() {
        viewInput?.getPlant(plant: plant)
        viewInput?.getFixedReminders(fixedReminders: [
            .init(reminderText: "Последняя обработка", reminderDate: "15.05.24"),
            .init(reminderText: "Последний полив", reminderDate: "28.05.24")])
        
        viewInput?.getReminders(remindersStruct: [
            .init(reminderText: "Собрать плоды", reminderDate: "12 августа"),
            .init(reminderText: "Обрезать ветки", reminderDate: "15 августа")])
        
        viewInput?.getTags(tagsStructs: [.init(name: "косточковые", color: .lightGreen),
                                        .init(name: "неприхотлива", color: .lightGreen),
                                        .init(name: "ягода", color: .lightGreen),
                                        .init(name: "все виды удобрений", color: .lightGreen),
                                        .init(name: "дневной полив", color: .lightGreen),
                                        .init(name: "сладкая", color: .lightGreen)])
        
        viewInput?.updateContent()
            
    }
}
