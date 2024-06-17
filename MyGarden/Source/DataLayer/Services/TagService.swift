//
//  TagService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import Foundation
import UIKit

class TagService {
    static var shared = TagService()
    private let repository = TagRepository.shared
    private init() {}
    
    func save(newTag: String) -> TagStruct? {
        if (newTag != "") {
            if let tag = repository.createTag(tag: .init(name: newTag.lowercased(), color: .generateRandomColor)) {
                //TODO: цвета разные настроить
                return .init(entity: tag)
            }
        }
        return nil
    }
    
    func getAllTags() -> [TagStruct] {
        return repository.fetchTags().map({.init(entity: $0)})
    }
    
    func getTag(withID id: UUID) -> TagStruct? {
        if let tagEntity = repository.fetchTagWith(id: id) {
            return .init(entity: tagEntity)
        } else {
            return nil
        }
    }
    
    func deleteAll() {
        repository.deleteAllTags()
    }
    
    
}
