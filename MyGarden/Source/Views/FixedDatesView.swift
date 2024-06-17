//
//  FixedDatesView.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 17.05.2024.
//

import UIKit

class FixedDatesView: UIView {
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
    
    var date: String? {
        set { dateLabel.text = newValue }
        get { return dateLabel.text }
    }
    
    var descriptionText: String? {
        set { descriptionLabel.text = newValue }
        get { return descriptionLabel.text }
    }
    
    private lazy var lineView: UIView = {
        var view = UIView()
        view.backgroundColor = .separatorGray
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

extension FixedDatesView {
    func setUp() {
        self.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(descriptionLabel)
        self.addSubview(lineView)
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints({$0.bottom.equalTo(horizontalStackView).offset(14)})
    }
}
