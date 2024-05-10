//
//  ViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 01.03.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension MainViewController {
    func setUp() {
        view.backgroundColor = .white
        
        let tv = TagCollectionView()
        
        tv.tagsStruct = [.init(name: "косточковые", color: .lightGreen),
                   .init(name: "неприхотлива", color: .lightGreen),
                   .init(name: "ягода", color: .lightGreen),
                   .init(name: "все виды удобрений", color: .lightGreen),
                   .init(name: "дневной полив", color: .lightGreen),
                   .init(name: "сладкая", color: .lightGreen)
        ]
        
        
        
        let tag = ReminderButton()
        
        
        view.addSubview(tag)
        view.addSubview(tv)
        
        tv.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(100)
//            make.bottom.equalToSuperview().inset(300)
            make.leading.trailing.equalToSuperview().inset(30)
//            make.width.equalToSuperview().inset(40)
        }
        
        
        tag.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(50)
        }
    }
}

