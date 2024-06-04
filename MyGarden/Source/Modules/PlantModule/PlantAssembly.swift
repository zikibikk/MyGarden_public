//
//  Assembly.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.05.2024.
//

import UIKit

enum ListOfPlantAssembly {
    static func assemble() -> UIViewController {
        let listPresenter = MockListOfPlantPresenter()
        let listController = ListOfPlantTVC(presenter: listPresenter)
        listPresenter.listViewInput = listController
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.barTintColor = .white
        
        navigationController.viewControllers = [listController]
        return navigationController
    }
}

//enum PlantAssembly {
//    static func assemble() -> UIViewController {
//        let plantPresenter = MockPlantPresenter()
//        
//        let plantViewController = PlantTableViewController(presenter: plantPresenter)
//        plantPresenter.viewInput = plantViewController
//        
//        return plantViewController
//    }
//}
