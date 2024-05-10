//
//  DayTableViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 01.05.2024.
//

import UIKit
import SnapKit

enum ModelTypes {
    case title
    case subtitle
    case note
    case reminderButton
    case reminder
    case plants
}

class DayTableViewController: UIViewController {
    
    private var presenter: iDayPresenter
    private var models: [(ModelTypes, String?)] = []
    private var reminders: [ReminderStruct] = []
    private var tags: [TagStruct] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "\(TitleTableViewCell.self)")
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "\(NoteTableViewCell.self)")
        tableView.register(ReminderButtonTableViewCell.self, forCellReuseIdentifier: "\(ReminderButtonTableViewCell.self)")
        tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: "\(ReminderTableViewCell.self)")
        tableView.register(TagTableViewCell.self, forCellReuseIdentifier: "\(TagTableViewCell.self)")
        
        return tableView
    }()
    
    init(presenter: iDayPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        switch model.0 {
        case .title:
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "\(TitleTableViewCell.self)", for: indexPath) as! TitleTableViewCell
            dateCell.text = model.1
            return dateCell
            
        case .note:
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "\(NoteTableViewCell.self)", for: indexPath) as! NoteTableViewCell
            noteCell.configureCell(noteText: model.1 ?? "")
            return noteCell
            
        case .reminderButton:
            let reminderButtonCell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderButtonTableViewCell.self)", for: indexPath) as! ReminderButtonTableViewCell
            return reminderButtonCell
            
        case .reminder:
            let reminderCell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderTableViewCell.self)", for: indexPath) as! ReminderTableViewCell
            reminderCell.configureCell(time: reminders[indexPath.row - 3].reminderDate, text: reminders[indexPath.row - 3].reminderText)
            return reminderCell
            
        case .subtitle:
            let subtitleCell = tableView.dequeueReusableCell(withIdentifier: "\(TitleTableViewCell.self)", for: indexPath) as! TitleTableViewCell
            subtitleCell.text = model.1
            subtitleCell.font = .subtitleFont
            return subtitleCell
            
        case .plants:
            let tagsCell = tableView.dequeueReusableCell(withIdentifier: "\(TagTableViewCell.self)", for: indexPath) as! TagTableViewCell
            tagsCell.configure(tagsStruct: self.tags)
            return tagsCell
        }
    }
}

extension DayTableViewController: iNoteView {
    
    func updateContent() {
        models.insert((ModelTypes.reminderButton, ""), at: 2)
        tableView.reloadData()
    }
    
    
    func getDate(dateText: String) {
        (models.first != nil) ? models[0] = (ModelTypes.title, dateText) : models.append((ModelTypes.title, dateText))
    }
    
    func getNoteText(noteText: String) {
        (models.count >= 2) ? models[1] = (ModelTypes.note, noteText) : models.append((ModelTypes.note, noteText))
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        for reminder in remindersStruct {
            models.append((ModelTypes.reminder, ""))
            self.reminders.append(reminder)
        }
    }
    
    func getTags(tagsStruct: [TagStruct]) {
        models.append((ModelTypes.subtitle, "Растения"))
        models.append((ModelTypes.plants, ""))
        tags = tagsStruct
    }
        
    func returnCurrentNoteText() -> String? {
        return ""
    }
    
    
}
