//
//  Assembly.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 07.05.2024.
//

import UIKit

enum DayAssembly {
    static func assemble() -> UIViewController {
        let notePresenter = MockDayPresenter()
        
        let noteViewController = DayTableViewController(presenter: notePresenter)
        notePresenter.viewInput = noteViewController
        
        return noteViewController
    }
}
