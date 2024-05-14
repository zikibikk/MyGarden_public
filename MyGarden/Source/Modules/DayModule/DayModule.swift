//
//  DayModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.04.2024.
//

import Foundation

protocol iNoteView: AnyObject {
    func getDate(dateText: String)
    func getNoteText(noteText: String)
    func getReminders(remindersStruct: [ReminderStruct])
    func getTags(tagsStruct: [TagStruct])
    func updateContent()
    func returnCurrentNoteText() -> String?
}

protocol iDayPresenter {
    var viewInput: iNoteView? { get set }
    func viewDidLoad()
    func viewWillDisapear()
}

protocol iNoteService {
    func saveNote(noteText: String?)
    func returnNoteByDate(date: Date) -> String
}

protocol iNoteRepository {
    func createNote(id: Int16, note: NoteStruct)
    func fetchNotes() -> [NoteEntity]
    func fetchNote(with date: Date) -> NoteEntity?
    func updateNote(with date: Date, newText: String)
    func deleteAllNotes()
    func deleteNote(with date: Date)
}
