//
//  DayPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 07.04.2024.
//

import Foundation

protocol iNoteRepository {
    func saveNote()
    func returnNoteByDate() -> String?
}
class NoteRepository {
    
}

protocol iNoteService {
    func saveNote(noteText: String?)
    func returnNoteByDate(date: Date) -> String
}
class NoteService: iNoteService {
    
    let repository: iNoteRepository
    let fillerString = "Начните писать заметку на сегодня"
    
    init(repository: iNoteRepository) {
        self.repository = repository
    }
    
    func saveNote(noteText: String?) {
        repository.saveNote()
    }
    
    func returnNoteByDate(date: Date) -> String {
        return repository.returnNoteByDate() ?? fillerString
    }
    
    
}
