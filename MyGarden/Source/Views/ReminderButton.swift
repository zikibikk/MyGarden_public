//
//  ReminderButton.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 26.04.2024.
//

import UIKit
import SnapKit

class ReminderButton: UIView {
    private lazy var buttonText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .reminderGray
        label.textAlignment = .left
        label.font = .reminderFont
        label.text = "Добавить напоминание"
        return label
    }()
    
    private lazy var plusImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.tintColor = .reminderGray
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        var view = UIView()
        view.backgroundColor = .reminderGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReminderButton {
    private func setUp() {
        
        self.addSubview(buttonText)
        self.addSubview(plusImageView)
        self.addSubview(lineView)
        
        buttonText.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        plusImageView.snp.makeConstraints { make in
            make.height.centerY.equalTo(buttonText)
            make.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(buttonText).offset(2)
        }
        
    }
}
