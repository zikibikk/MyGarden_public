//
//  DayTableViewCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 30.04.2024.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    private lazy var noteView = NoteView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoteTableViewCell {
    func configureView() {
        noteView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(20)
        }
    }
}
