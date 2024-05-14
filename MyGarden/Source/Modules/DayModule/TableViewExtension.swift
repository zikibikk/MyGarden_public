//
//  TableViewExtension.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 10.05.2024.
//

import UIKit

extension DayTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        switch model.0 {
        case .title:
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "\(TitleTableViewCell.self)", for: indexPath) as! TitleTableViewCell
            dateCell.text = model.1[0]
            return dateCell
            
        case .note:
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "\(NoteTableViewCell.self)", for: indexPath) as! NoteTableViewCell
            noteCell.configureCell(noteText: model.1[0])
            return noteCell
            
        case .reminderButton:
            let reminderButtonCell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderButtonTableViewCell.self)", for: indexPath) as! ReminderButtonTableViewCell
            return reminderButtonCell
            
        case .reminder:
            let reminderCell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderTableViewCell.self)", for: indexPath) as! ReminderTableViewCell
            reminderCell.configureCell(time: model.1[0], text: model.1[1])
            return reminderCell
            
        case .subtitle:
            let subtitleCell = tableView.dequeueReusableCell(withIdentifier: "\(TitleTableViewCell.self)", for: indexPath) as! TitleTableViewCell
            subtitleCell.text = model.1[0]
            subtitleCell.font = .subtitleFont
            return subtitleCell
            
        case .plants:
            let tagsCell = tableView.dequeueReusableCell(withIdentifier: "\(TagTableViewCell.self)", for: indexPath) as! TagTableViewCell
            tagsCell.configure(tagsStruct: self.tags)
            return tagsCell
        }
    }
}
