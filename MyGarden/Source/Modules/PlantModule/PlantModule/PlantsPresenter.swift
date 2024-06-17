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
        viewInput?.getFixedDates(fixedReminders: [.init(id: UUID(), reminderText: "Последний полив", reminderTime: "17:00", reminderDate: "9 июня", reminderDateWithTime: Date())])
        viewInput?.getReminders(remindersStruct: plantService.getPlantReminders(plant: plant))
//        viewInput?.getReminders(remindersStruct: plant.reminders)
//        plantService.remove(tag: plantService.getTags(forPlant: plant).last!, fromPlant: plant)
        viewInput?.getTags(tagsStruct: plantService.getTags(forPlant: plant))
        
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

extension MockPlantPresenter: TagCollectionViewDelegate {
    func pressedTag(withID id: UUID) {
        
    }
    
    func addTagButtonPressedOnCollectionView() {
        let tagPresenter = TagsPresenter(delegate: self)
        let tagViewController = TagViewController(presenter: tagPresenter)
        tagPresenter.inputView = tagViewController
        
        if let sheet = tagViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        viewInput?.present(tagViewController, animated: true)
    }
}

extension MockPlantPresenter: tagSelectionDelegate {
    func selectedTag(_ tag: TagStruct) {
        plantService.add(tag: tag, toPlant: plant)
        viewInput?.addTag(tagsStruct: tag)
    }
}

extension MockPlantPresenter: iPhotablePresenter {
    func photoImagePressed() {
        viewInput?.navigationController?.pushViewController(PhotoAssemble.assembly(plant: plant), animated: true)
    }
}
