//
//  RemindButtonTableViewCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 02.05.2024.
//

import UIKit

class ReminderButtonTableViewCell: UITableViewCell {
    
    private lazy var reminderButton = ReminderButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReminderButtonTableViewCell {
    func configureCell() {
        selectionStyle = .none
        contentView.addSubview(reminderButton)
        
        reminderButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(26)
        }
        
        contentView.snp.makeConstraints({$0.bottom.equalTo(reminderButton)})
        contentView.snp.makeConstraints({$0.width.equalToSuperview()})
    }
}
