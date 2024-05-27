//
//  FixCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 08.05.2024.
//

import UIKit

class FixedPlantTableViewCell: UITableViewCell {
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 27
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .reminderGray
        label.textAlignment = .left
        label.font = .reminderFont
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .reminderGray
        label.textAlignment = .left
        label.font = .reminderFont
        return label
    }()
    
    private lazy var lineView: UIView = {
        var view = UIView()
        view.backgroundColor = .separatorGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FixedPlantTableViewCell {
    func configureCell(date: String, description: String) {
        
        selectionStyle = .none
        
        dateLabel.text = date
        descriptionLabel.text = description
        
        self.contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(descriptionLabel)
        self.addSubview(lineView)
        
        horizontalStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(38)
            make.top.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints({$0.bottom.equalTo(horizontalStackView).offset(14)})
    }
}
