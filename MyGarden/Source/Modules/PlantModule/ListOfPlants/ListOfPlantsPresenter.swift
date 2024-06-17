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
    
    //TODO: сделать обновление структур и после viewwillappear
    func viewDidLoad() {
        listViewInput?.getListOfPlants(plants: plantService.getAllPlants())
        listViewInput?.title = nil
    }
    
    func viewWillAppear() {
        listViewInput?.getListOfPlants(plants: plantService.getAllPlants())
        listViewInput?.title = nil
    }
    
    
    func selectedPlant(plant: PlantStruct) {
        let plantPresenter = MockPlantPresenter(plant: plant)
        
        let plantViewController = PlantScrollViewController(presenter: plantPresenter)
        plantPresenter.viewInput = plantViewController
        
        listViewInput?.navigationController?.pushViewController(plantViewController, animated: true)
    }
    
    func createPlant() {
        let addPlant = AddPlantViewController(delegate: self)
        if let sheet = addPlant.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        listViewInput?.present(addPlant, animated: true)
    }
}

extension MockListOfPlantPresenter: addPlantDelegate {
    func getPlant(name: String) {
        if let newPlant = plantService.savePlant(withName: name) {
            selectedPlant(plant: newPlant)
        }
        listViewInput?.dismiss(animated: true)   
    }
}
