//
//  TagsPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import Foundation

class TagsPresenter: iTagPresenter {
    
    
    weak var inputView: iTagViewController?
    
    private let service = TagService.shared
    
    func viewDidLoad() {
        inputView?.getTitle("Теги")
        inputView?.getTags(tagsStruct: service.getAllTags())
    }
    
    func addTagButtonPressed(newTag: String) {
        if let createdTag = service.save(newTag: newTag) {
            inputView?.addTag(tagsStruct: createdTag)
        }
    }
    
}

extension TagsPresenter: TagCollectionViewDelegate {
    func pressedTag(id: UUID) {
        print("From TagCollectionViewDelegate pressedTag with id \(id) ")
        service.
    }
    
    func addTagButtonPressed() {
        
    }
}
