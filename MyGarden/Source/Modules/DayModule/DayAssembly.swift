//
//  Assembly.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 07.05.2024.
//

import UIKit

enum DayAssembly {
    static func assemble(forDate: Date) -> UIViewController {
        let notePresenter = MockDayPresenterWithNoteService(date: forDate)
        
        let noteViewController = DayScrollController(presenter: notePresenter)
        notePresenter.viewInput = noteViewController
        
        return noteViewController
    }
}
