//
//  DayPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 07.04.2024.
//

import Foundation

class MockDayPresenter: iDayPresenter {
    weak var viewInput: iNoteView?
    
    func viewDidLoad() {
        viewInput?.getDate(dateText: "Сегодня, 29 апреля")
        viewInput?.getNoteText(noteText: "Высадила семена томата в стаканчики. Очень долго шли из Самары, и теперь надо успеть до конца следующей недели вырастить крепкие саженцы: погоду обещают хорошую, снег быстрее растает. Обрезала сухие ветки ежевики, вечером сожгла.")
        viewInput?.getReminders(remindersStruct: [
            .init(reminderText: "Высадить ежевику", reminderDate: "17:30"),
            .init(reminderText: "Удобрить розы", reminderDate: "20:45")])
        viewInput?.getTags(tagsStruct: [.init(name: "косточковые", color: .lightGreen),
                                        .init(name: "неприхотлива", color: .lightGreen),
                                        .init(name: "ягода", color: .lightGreen),
                                        .init(name: "все виды удобрений", color: .lightGreen),
                                        .init(name: "дневной полив", color: .lightGreen),
                                        .init(name: "сладкая", color: .lightGreen)])
        viewInput?.updateContent()
    }
    
    func viewWillDisapear() {
        print(viewInput?.returnCurrentNoteText() ?? "no value")
    }
}


class DayPresenter: iDayPresenter {
    
    
    private var noteDate: Date
    var viewInput: iNoteView?
    private var noteService: iNoteService
    
    init(noteDate: Date, noteService: iNoteService) {
        self.noteDate = noteDate
        self.noteService = noteService
    }
    
    func viewDidLoad() {
        viewInput?.getNoteText(noteText: noteService.returnNoteByDate(date: noteDate))
    }
    
    func viewWillDisapear() {
        noteService.saveNote(noteText: viewInput?.returnCurrentNoteText())
    }
}
