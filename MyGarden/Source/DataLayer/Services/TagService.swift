//
//  TagService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import Foundation

class TagService {
    static var shared = TagService()
    private let repository = TagRepository.shared
    private init() {}
    
    func save(newTag: String) -> TagStruct? {
        if (newTag != "") {
            if let tag = repository.createTag(tag: .init(name: newTag.lowercased(), color: .lightGreen)) {
                //TODO: цвета разные настроить
                return .init(entity: tag)
            }
        }
        return nil
    }
    
    func getAllTags() -> [TagStruct] {
        return repository.fetchTags().map({.init(entity: $0)})
    }
    
    func deleteAll() {
        repository.deleteAllTags()
    }
    
    
}
