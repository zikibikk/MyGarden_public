//
//  ListOfPlantsOresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 31.05.2024.
//

import Foundation

class MockListOfPlantPresenter: iListOfPlantsPresenter {
    
    var listViewInput: iListOfPlantsView?
    private let plantService = PlantService.shared
    
    func viewDidLoad() {
        listViewInput?.getListOfPlants(plants: plantService.getAllPlants())
    }
    
    
    func selectedPlant(plant: PlantStruct) {
        let plantPresenter = MockPlantPresenter(plant: plant)
        
        let plantViewController = PlantScrollViewController(presenter: plantPresenter)
        plantPresenter.viewInput = plantViewController
        
        listViewInput?.navigationController?.pushViewController(plantViewController, animated: true)
    }
}
