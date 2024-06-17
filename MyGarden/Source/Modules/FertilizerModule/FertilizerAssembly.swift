//
//  FertilizerAssembly.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.06.2024.
//

import UIKit

enum FertilizerAssembly {
    static func assemble() -> UIViewController {
        let presenter = FertilizersPresenter()
        let viewController = FertilizerTableViewController(presenter: presenter)
        presenter.inputView = viewController
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.barTintColor = .white
        
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}
