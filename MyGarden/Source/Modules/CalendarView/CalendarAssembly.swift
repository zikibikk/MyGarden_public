//
//  CalendarAssembly.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.05.2024.
//

import UIKit

enum CalendarAssembly {
    static func assemble() -> UIViewController {
        
        let calendarViewController = CalendarViewController(presenter: nil)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.barTintColor = .white
        
        navigationController.viewControllers = [calendarViewController]
        return navigationController
    }
}
