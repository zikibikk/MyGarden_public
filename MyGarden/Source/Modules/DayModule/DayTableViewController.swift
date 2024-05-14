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
    internal var models: [(ModelTypes, [String])] = []
    internal var tags: [TagStruct] = []
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
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
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DayTableViewController {
    @objc func handleTap() {
        view.endEditing(true)
    }
}

extension DayTableViewController: iNoteView {
    
    
    func updateContent() {
        tableView.reloadData()
    }
    
    
    func getDate(dateText: String) {
        (models.first != nil) ? models[0] = (ModelTypes.title, [dateText]) : models.append((ModelTypes.title, [dateText]))
    }
    
    func getNoteText(noteText: String) {
        (models.count >= 2) ? models[1] = (ModelTypes.note, [noteText]) : models.append((ModelTypes.note, [noteText]))
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        models.append((ModelTypes.reminderButton, [""]))
        
        for reminder in remindersStruct {
            models.append((ModelTypes.reminder, [reminder.reminderDate, reminder.reminderText]))
        }
    }
    
    func getTags(tagsStruct: [TagStruct]) {
        models.append((ModelTypes.subtitle, ["Растения"]))
        models.append((ModelTypes.plants, []))
        tags = tagsStruct
    }
        
    func returnCurrentNoteText() -> String? {
        return ""
    }
    
    
}
