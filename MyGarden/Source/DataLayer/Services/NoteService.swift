//
//  NoteRepositoryService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.05.2024.
//

import Foundation

class NoteService {
    
    let fillerString = "Начните писать заметку на сегодня"
    let repository: NoteRepository
    
    static var shared = NoteService(repository: NoteRepository.shared)
    
    private init(repository: NoteRepository) {
        self.repository = repository
    }
    
    
    
    func testWork() {
        repository.test()
        print("first aaa")
    }
}
