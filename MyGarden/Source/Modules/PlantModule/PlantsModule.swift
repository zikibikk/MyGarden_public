//
//  PlantsModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 08.05.2024.
//

import UIKit

protocol iListOfPlantsView: UIViewController {
    func getListOfPlants(plants: [PlantStruct])
}

protocol iListOfPlantsPresenter {
    var listViewInput: iListOfPlantsView? { get set }
    func viewDidLoad()
    func selectedPlant(plant: PlantStruct)
}

protocol iPlantRepository {
    func createPlant(plant: PlantStruct)
    func fetchPlants() -> [PlantEntity]
    func fetchPlantWith(id: UUID)
    func fetchPlantWith(name: String)
    func deleteAllPlants()
    func deletePlantWith(id: UUID)
}

protocol iPlantView: UIViewController, remindableView {
    func getPlantName(_ plant: String)
    func getFixedDates(fixedReminders: [ReminderStruct])
    func addFixedDates(fixedReminder: ReminderStruct)
    func getReminders(remindersStruct: [ReminderStruct])
    func getTags(tagsStructs: [TagStruct])
}

protocol iPlantPresenter: addReminderDelegate {
    var viewInput: iPlantView? { get set }
    var plant: PlantStruct { get }
    func viewDidLoad()
    init(plant: PlantStruct)
}
