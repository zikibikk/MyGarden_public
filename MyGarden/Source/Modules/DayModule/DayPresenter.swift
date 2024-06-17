//
//  DayPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 07.04.2024.
//

import UIKit
//TODO: решить, удалять растения и теги вместе с заметкой или нет
class MockDayPresenterWithNoteService: iDayPresenter {
    
    weak var viewInput: iNoteView?
    private var date: Date
    private var noteService = NoteService.shared
    private var reminderService = ReminderService.shared
    private var note: NoteStruct?
    
    init(date: Date) {
        self.date = date
        self.note = noteService.getNoteS(with: date)
    }
    
    func viewDidLoad() {
        
        viewInput?.getDate(dateText: date.getDayWithWeekString())
        viewInput?.getNoteText(noteText: noteService.getNote(with: date))
//        reminderService.deleteReminder(reminder: reminderService.getRemindersForDate(date: date).last!)
        viewInput?.getReminders(remindersStruct: reminderService.getRemindersForDate(date: date))
        if let note = noteService.getNoteS(with: date) {
            //TODO: цвет
            viewInput?.getTags(tagsStruct: noteService.getAllPlants(fromNote: note).map({TagStruct(id: $0.id, name: $0.name, color: .generateRandomColor)}))
        }
    }
    
    func viewEndedEditing() {
        guard let text = viewInput?.returnCurrentNoteText() else { return }
        
        if (text != "") {
            noteService.saveOrUpdate(note: .init(text: text, date: date))
        } else {
            //TODO: выводить предупреждение об удалении всех прикреплённых записей
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

extension MockDayPresenterWithNoteService: tagSelectionDelegate {
    func selectedTag(_ tag: TagStruct) {
        if let note = note {
            if let plantS = noteService.add(plantWithId: tag.id, toNote: note) {
                viewInput?.addTag(tagsStruct: .init(name: plantS.name, color: .generateRandomColor))
            }
            viewInput?.dismiss(animated: true)
        } else {
            print("Заметки нет, не к чему добавлять")
        }
        
    }
}

extension MockDayPresenterWithNoteService: TagCollectionViewDelegate {
    func pressedTag(withID id: UUID) {
        //TODO: push plant view controller
    }
    
    func addTagButtonPressedOnCollectionView() {
        let tagPresenter = PlantsAsTagsPresenter(delegate: self) //TagsPresenter(delegate: self)
        let tagViewController = AddPlantViewControllerAsTag(presenter: tagPresenter) //TagViewController(presenter: tagPresenter)
        tagPresenter.inputView = tagViewController
        
        if let sheet = tagViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        viewInput?.present(tagViewController, animated: true)
    }
}
