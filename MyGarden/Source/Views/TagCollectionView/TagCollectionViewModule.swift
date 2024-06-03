//
//  TagModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 02.06.2024.
//

import Foundation

protocol TagViewDelegate {
    func pressedTag(id: UUID, title: String)
}

protocol TagCollectionViewDelegate {
    func pressedTag(id: UUID)
    func addTag()
}

protocol TagableView {
    func getTags(tagsStruct: [TagStruct])
    func addTag(tagsStruct: TagStruct)
}
