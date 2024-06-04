//
//  TagViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import UIKit
import SnapKit

class TagViewController: UIViewController {
    private let presenter: iTagPresenter
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .subtitleFont
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Новый тег"
        tf.borderStyle = .roundedRect
        tf.tintColor = .myGreen
        tf.keyboardType = .default
        tf.enablesReturnKeyAutomatically = true
        return tf
    }()
    
    private lazy var addNewTagButton: TagView = {
        let tagView = TagView()
        tagView.tagViewDelegate = self
        tagView.tagStruct = .init(name: "+", color: .lightGreen)
        return tagView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let hv = UIStackView()
        hv.axis = .horizontal
        hv.spacing = 8
        return hv
    }()
    
    private lazy var tagCollectionView: TagCollectionView = {
        let tagCollectionView = TagCollectionView()
        tagCollectionView.tagCollectionDelegate = presenter
        tagCollectionView.hasAddButton = false
        return tagCollectionView
    }()
    
    private lazy var verticalView: UIStackView = {
        let hv = UIStackView()
        hv.axis = .vertical
        hv.spacing = 8
        return hv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
    
    init(presenter: iTagPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagViewController: TagViewDelegate {
    func pressedTag(id: UUID, title: String) {
        guard let newTagName = textField.text else { return }
        presenter.addTagButtonPressed(newTag: newTagName)
    }
}

extension TagViewController: iTagViewController {
    func getTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func getTags(tagsStruct: [TagStruct]) {
        tagCollectionView.tagsStruct = tagsStruct
    }
    
    func addTag(tagsStruct: TagStruct) {
        tagCollectionView.insert(newTag: tagsStruct)
    }
}

extension TagViewController {
    func setUp() {
        self.view.backgroundColor = .white
        self.view.addSubview(verticalView)
        
        verticalView.snp.makeConstraints { maker in
            maker.left
                .right
                .equalToSuperview()
                .inset(15)
            maker.top.equalToSuperview()
                .inset(20)
        }
        
        horizontalStackView.addArrangedSubview(textField)
        horizontalStackView.addArrangedSubview(addNewTagButton)
        
        verticalView.addArrangedSubview(titleLabel)
        verticalView.addArrangedSubview(horizontalStackView)
        verticalView.addArrangedSubview(tagCollectionView)
        
    }
}
