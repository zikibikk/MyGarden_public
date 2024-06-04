//
//  TagsModule.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import UIKit

protocol iTagViewController: UIViewController, TagableView {
    func getTitle(_ title: String)
}

protocol iTagPresenter: TagCollectionViewDelegate {
    var inputView: iTagViewController? { get set }
    func viewDidLoad()
    func addTagButtonPressed(newTag: String)
}
