//
//  ReminderTableViewCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 02.05.2024.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    private lazy var reminderView = RemindView()
    
}

extension ReminderTableViewCell {
    func configureCell(time: String, text: String) {
        selectionStyle = .none
        reminderView.time = time
        reminderView.descriptionText = text
        contentView.addSubview(reminderView)
        
        reminderView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(27)
            make.left.equalToSuperview().inset(34)
            make.right.equalToSuperview().inset(10)
        }
        
        contentView.snp.makeConstraints({$0.bottom.equalTo(reminderView)})
        contentView.snp.makeConstraints({$0.width.equalToSuperview()})
    }
}
