//
//  PlantasPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 08.05.2024.
//

import Foundation

class MockPlantPresenter: iPlantPresenter {
    var plant: PlantStruct
    weak var viewInput: iPlantView?
    private let plantService = PlantService.shared
    
    required init(plant: PlantStruct) {
        self.plant = plant
    }
    
    func viewDidLoad() {
        viewInput?.getPlantName(plant.name)
        //TODO: напоминания на сегодня фильтровать из напоминаний, которые уже хранятся в растении
        viewInput?.getReminders(remindersStruct: plant.reminders)
        
        viewInput?.getTags(tagsStructs: [.init(name: "косточковые", color: .lightGreen),
                                        .init(name: "неприхотлива", color: .lightGreen),
                                        .init(name: "ягода", color: .lightGreen),
                                        .init(name: "все виды удобрений", color: .lightGreen),
                                        .init(name: "дневной полив", color: .lightGreen),
                                        .init(name: "сладкая", color: .lightGreen)])
        
    }
}

extension MockPlantPresenter: addReminderDelegate {
    func addNewReminderToView(newStruct: ReminderStruct) {
        plantService.add(reminder: newStruct, toPlant: plant)
        viewInput?.addReminderView(reminderStruct: newStruct)
    }
    
    func pressedAddReminderButton() {
        let addReminderController = AddReminderController(addReminderDelegate: self)
        if let sheet = addReminderController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        viewInput?.present(addReminderController, animated: true)
    }
}
