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
        
        viewInput?.getTags(tagsStructs: [.init(name: "косточковые", color: .lightGreen),
                                        .init(name: "неприхотлива", color: .lightGreen),
                                        .init(name: "ягода", color: .lightGreen),
                                        .init(name: "все виды удобрений", color: .lightGreen),
                                        .init(name: "дневной полив", color: .lightGreen),
                                        .init(name: "сладкая", color: .lightGreen)])
        
        viewInput?.updateContent()
    }
}

extension MockPlantPresenter: addReminderDelegate {
    func addNewReminderToView(newStruct: ReminderStruct) {
        plantService.addReminderToPlant(newStruct, toPlant: plant)
//        viewInput?.addReminderView(reminderStruct: newStruct)
    }
    
    func pressedAddReminderButton() {
        let addReminderController = AddReminderController(addReminderDelegate: self)
        if let sheet = addReminderController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        viewInput?.present(addReminderController, animated: true)
    }
}
