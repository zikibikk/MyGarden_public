//
//  NoteRepositoryService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.05.2024.
//

import Foundation

class NoteService: iNoteService {
    
    let fillerString = "Начните вводить заметку"
    let repository: NoteRepository
    
    static var shared = NoteService(repository: NoteRepository.shared)
    
    private init(repository: NoteRepository) {
        self.repository = repository
    }
    
    func getNote(with date: Date) -> String {
        let noteEntity = repository.fetchNote(with: date.removeTime())
        return noteEntity?.text ?? fillerString
    }
    
    func getNoteS(with date: Date) -> NoteStruct? {
        guard let noteE = repository.fetchNote(with: date.removeTime()) else { return nil }
        return .init(entity: noteE)
    }
    
    func saveOrUpdate(note: NoteStruct) {
        guard note.text != fillerString else { return }
        let noteWithNoTime = getNoteWithNoTime(from: note)
        if repository.updateNote(with: noteWithNoTime.date, newText: noteWithNoTime.text) {
            return
        } else {
            repository.createNote(note: noteWithNoTime)
        }
    }
    
    func addTagToNote(_ tag: TagStruct, toNote note: NoteStruct) {
        repository.addTagToNote(tag, toNote: note)
    }
    
    func getNoteTags(note: NoteStruct) -> [TagStruct] {
        repository.fethNoteTags(note: note).map({.init(entity: $0)})
    }
    
    func removeTagFromNote(tag: TagStruct, note: NoteStruct) {
        TagRepository.shared.remove(fromNote: note, tag: tag)
    }
    
    func deleteNote(note: NoteStruct) {
        if (repository.deleteNote(with: note.date)){
            print("note \(note.text) successfully deleted")
        } else {
            print("note hasn't been deleted")
        }
    }
    
    func deleteNote(with date: Date) {
        if (repository.deleteNote(with: date.removeTime())) {
            print("note with date \(date) successfully deleted")
        } else {
            print("note hasn't been deleted")
        }
    }
    
    func deleteAllNotes() {
        repository.deleteAllNotes()
    }
    
    func testWork() {
        print("There are \(repository.fetchNotes().count) in repo")
        
        
    }
}

extension Date {
    func removeTime() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Moscow")!
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    func getTime() -> String {
        return String(self.formatted().split(separator: " ")[1])
    }
    
    func getDayWithMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM "
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    func getDayWithWeekString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM "
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}

extension NoteService {
    func getNoteWithNoTime(from note: NoteStruct) -> NoteStruct {
        return .init(id: note.id, text: note.text, date: note.date.removeTime())
    }
    
}
