//
//  DayTableViewCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 30.04.2024.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .titleFont
        dayLabel.textColor = .black
        return dayLabel
    }()
    
    var text: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleTableViewCell {
    func configureCell() {
        self.selectionStyle = .none
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(40)
        }
        
        contentView.snp.makeConstraints({$0.bottom.equalTo(titleLabel)})
    }
}
