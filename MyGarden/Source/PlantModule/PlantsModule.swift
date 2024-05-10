//
//  PlantsModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 08.05.2024.
//

import Foundation

protocol iPlantView: AnyObject {
    func updateContent()
    func getPlant(plant: String)
    func getFixedReminders(fixedReminders: [ReminderStruct])
    func getReminders(remindersStruct: [ReminderStruct])
    func getTags(tagsStructs: [TagStruct])
}

protocol iPlantPresenter {
    var viewInput: iPlantView? { get set }
    func viewWillAppear()
}
