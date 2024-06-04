//
//  ReminderService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 28.05.2024.
//

import Foundation

class ReminderService: iReminderService {
    
    let repository: ReminderRepository
    
    static var shared = ReminderService(repository: ReminderRepository.shared)
    
    private init(repository: ReminderRepository) {
        self.repository = repository
    }
    
    func saveReminder(date: Date, text: String) -> ReminderStruct? {
        if text.isEmpty { return nil }
        else {
            guard let entity = repository.createReminder(dateWithoutTime: date.removeTime(), dateWithTime: date, text: text) else { return nil }
            return .init(entity: entity)
        }
    }
    
    func getRemindersForDate(date: Date) -> [ReminderStruct] {
        return repository.fetchReminders(withDateWithoutTime: date.removeTime())?.sorted(by: {$0.dateWithTime < $1.dateWithTime}).map({ entity in
            return ReminderStruct(entity: entity)
        }) ?? []
    }
    
    func deleteReminder(reminder: ReminderStruct) {
        repository.deleteReminder(withId: reminder.id)
    }
    
    
    
    func test() {
        print("there are \(repository.fetchAllReminders().count) reminders")
        
    }
    
    
    
}
