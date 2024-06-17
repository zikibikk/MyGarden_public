//
//  DayModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.04.2024.
//

//TODO: после добавления заметки, тэги её не видят и не добавляют


import UIKit

protocol iNoteView: UIViewController, remindableView, TagableView {
    func getDate(dateText: String)
    func getNoteText(noteText: String)
    func returnCurrentNoteText() -> String?
}

protocol iDayPresenter: addReminderDelegate, TagCollectionViewDelegate, tagSelectionDelegate {
    var viewInput: iNoteView? { get set }
    func viewEndedEditing()
    func viewDidLoad()
    func viewWillDisapear()
}

protocol iNoteService {
    func getNote(with date: Date) -> String
    func saveOrUpdate(note: NoteStruct)
    func deleteNote(note: NoteStruct)
    func deleteNote(with date: Date)
}

protocol iNoteRepository {
    func createNote(note: NoteStruct)
    func fetchNotes() -> [NoteEntity]
    func fetchNote(with date: Date) -> NoteEntity?
    func updateNote(with date: Date, newText: String) -> Bool
    func deleteAllNotes()
    func deleteNote(with date: Date) -> Bool
}
