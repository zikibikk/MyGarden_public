//
//  ReminderView.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 30.03.2024.
//

import UIKit
import SnapKit

class RemindView: UIView {
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .noteFont
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .noteFont
        label.numberOfLines = 3
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var rhombusImageView = UIImageView(image: UIImage(named: "Rhombus"))
    
    var time: String? {
        set { timeLabel.text = newValue }
        get { return timeLabel.text }
    }
    
    var descriptionText: String? {
        set { descriptionLabel.text = newValue }
        get { return descriptionLabel.text }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension RemindView {
    private func setUp() {
        self.addSubview(timeLabel)
        self.addSubview(rhombusImageView)
        self.addSubview(descriptionLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        rhombusImageView.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(10)
            make.centerY.equalTo(timeLabel)
        }
        
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(rhombusImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(timeLabel.snp.top)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
