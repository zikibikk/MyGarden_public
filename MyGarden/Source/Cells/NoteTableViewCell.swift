//
//  NoteTableViewCell.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 01.05.2024.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    lazy var noteView = NoteView()
    
}

extension NoteTableViewCell {
    func configureCell(noteText: String) {
        self.selectionStyle = .none
        noteView.text = noteText
        contentView.addSubview(noteView)
        
        noteView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(noteView)
            make.width.equalToSuperview()
        }
    }
}
