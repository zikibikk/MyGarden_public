//
//  TagTableViewCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 04.05.2024.
//

import UIKit
import SnapKit

class TagTableViewCell: UITableViewCell {
    
    private let tagCollectionView = TagCollectionView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        setUp()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TagTableViewCell {
    
    func configure(tagsStruct: [TagStruct]) {
        tagCollectionView.tagsStruct = tagsStruct
        
        setUp()
        
    }
    
    func setUp() {
        contentView.addSubview(tagCollectionView)
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        //TODO: убрать хардкод
        contentView.snp.makeConstraints { make in
            make.width.equalTo(393)
            make.bottom.equalTo(tagCollectionView)
        }
        
        layoutIfNeeded()
    }
}
