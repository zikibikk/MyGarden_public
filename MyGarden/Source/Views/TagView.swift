//
//  TagView.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 04.04.2024.
//
import UIKit
import SnapKit

class TagView: UIView {
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        label.font = .tagFont
        return label
    }()
    
    var tagStruct: TagStruct? {
        set { 
            tagLabel.text = newValue?.name.lowercased()
            self.backgroundColor = newValue?.color
        }
        get { return .init(name: tagLabel.text ?? "", color: self.backgroundColor ?? UIColor())}
    }
    
    private var tagName: String? {
        set { tagLabel.text = newValue?.lowercased() }
        get { return tagLabel.text }
    }
    
    private var color: UIColor? {
        set { self.backgroundColor = newValue }
        get { return self.backgroundColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagView {
    private func setUp() {
        self.layer.cornerRadius = 13
        self.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(9)
        }
        self.snp.makeConstraints { make in
            make.bottom.equalTo(tagLabel).offset(8)
            make.trailing.equalTo(tagLabel).offset(9)
        }
    }
}
