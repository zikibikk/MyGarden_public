//
//  TagsPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import UIKit

class TagsPresenter: iTagPresenter {
    
    private var delegate: tagSelectionDelegate
    
    weak var inputView: iTagViewController?
    
    private let service = TagService.shared
    
    func viewDidLoad() {
        inputView?.getTitle("Теги")
        inputView?.getTags(tagsStruct: service.getAllTags())
    }
    
    func addTagButtonPressed(newTag: String) {
        if let createdTag = service.save(newTag: newTag) {
            inputView?.addTag(tagsStruct: createdTag)
            delegate.selectedTag(createdTag)
        }
    }
    
    init(delegate: tagSelectionDelegate) {
        self.delegate = delegate
    }
    
}

extension TagsPresenter: TagCollectionViewDelegate {
    func pressedTag(withID id: UUID) {
        if let tag = service.getTag(withID: id) {
            delegate.selectedTag(tag)
            inputView?.dismiss(animated: true)
        }
    }
    
    func addTagButtonPressedOnCollectionView() {
        
    }
}

class PlantsAsTagsPresenter: iTagPresenter {
    
    private var delegate: tagSelectionDelegate
    
    weak var inputView: iTagViewController?
    
    private let service = PlantService.shared
    
    init(delegate: tagSelectionDelegate) {
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        inputView?.getTitle("Растения")
        //TODO: ЦВЕТ
        let tags = service.getAllPlants().map({TagStruct(id: $0.id, name: $0.name, color: .lightGreen)})
        inputView?.getTags(tagsStruct: tags)
    }
    
    func addTagButtonPressed(newTag: String) {
        
    }
    
    func pressedTag(withID id: UUID) {
        delegate.selectedTag(.init(id: id, name: "", color: .lightGreen))
    }
    
    func addTagButtonPressedOnCollectionView() {
        
    }
    
}
