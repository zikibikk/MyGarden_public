//
//  PlantsModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 08.05.2024.
//

import UIKit

protocol iListOfPlantsView: UIViewController {
    func getListOfPlants(plantsNames: [String])
}

protocol iListOfPlantsPresenter {
    var listViewInput: iListOfPlantsView? { get set }
    func viewDidLoad()
    func selectedPlant(plant: String)
}

protocol iPlantView: AnyObject {
    func updateContent()
    func getPlant(plant: String)
    func getFixedReminders(fixedReminders: [ReminderStruct])
    func getReminders(remindersStruct: [ReminderStruct])
    func getTags(tagsStructs: [TagStruct])
}

protocol iPlantPresenter {
    var viewInput: iPlantView? { get set }
    var plant: String { get }
    func viewDidLoad()
    init(plant: String)
}
