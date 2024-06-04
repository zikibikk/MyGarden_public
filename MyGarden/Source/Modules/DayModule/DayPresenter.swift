//
//  DayPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 07.04.2024.
//

import Foundation
//TODO: решить, удалять растения и теги вместе с заметкой или нет
class MockDayPresenterWithNoteService: iDayPresenter {
    
    weak var viewInput: iNoteView?
    private var date: Date
    private var noteService = NoteService.shared
    private var reminderService = ReminderService.shared
    
    init(date: Date) {
        self.date = date
    }
    
    func viewDidLoad() {
        
        viewInput?.getDate(dateText: date.getDayWithWeekString())
        viewInput?.getNoteText(noteText: noteService.getNote(with: date))
        viewInput?.getReminders(remindersStruct: reminderService.getRemindersForDate(date: date))
        if let note = noteService.getNoteS(with: date) {
            viewInput?.getTags(tagsStruct: noteService.getNoteTags(note: note))
        }
    }
    
    func viewEndedEditing() {
        guard let text = viewInput?.returnCurrentNoteText() else { return }
        
        if (text != "") {
            noteService.saveOrUpdate(note: .init(text: text, date: date))
        } else {
            noteService.deleteNote(with: date)
        }
    }
    
    func viewWillDisapear() {
        
    }
    
}

extension MockDayPresenterWithNoteService: addReminderDelegate {
    func addNewReminderToView(newStruct: ReminderStruct) {
        viewInput?.addReminderView(reminderStruct: newStruct)
    }
    
    func pressedAddReminderButton() {
        let addReminderController = AddReminderController(addReminderDelegate: self)
        if let sheet = addReminderController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        viewInput?.present(addReminderController, animated: true)
    }
}

extension MockDayPresenterWithNoteService: TagCollectionViewDelegate {
    func pressedTag(id: UUID) {
        
    }
    
    func addTagButtonPressed() {
        let tagPresenter = TagsPresenter()
        let tagViewController = TagViewController(presenter: tagPresenter)
        tagPresenter.inputView = tagViewController
        
        if let sheet = tagViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        viewInput?.present(tagViewController, animated: true)
//        viewInput?.addTag(tagsStruct: .init(name: "m", color: .lightGreen))
    }
}
