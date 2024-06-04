//
//  ReminderModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 28.05.2024.
//

import UIKit

protocol iAddReminderView {
    
}

protocol iReminderService {
    func saveReminder(date: Date, text: String) -> ReminderStruct?
}

protocol iReminderPresenter {
    func pressedAddReminderButton(date: Date, text: String)
}

protocol addReminderDelegate {
    func pressedAddReminderButton()
    func addNewReminderToView(newStruct: ReminderStruct)
}

//TODO: сделать сортировку отображения при добавлении нового напоминания
protocol remindableView: UIViewController {
    func getReminders(remindersStruct: [ReminderStruct])
    func addReminderView(reminderStruct: ReminderStruct)
}
