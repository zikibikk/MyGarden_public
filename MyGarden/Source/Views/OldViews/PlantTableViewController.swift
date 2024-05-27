//
//  PlantViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 30.04.2024.
//

import UIKit
import SnapKit

enum PlantModels {
    case plantName
    case fixed
    case reminderButton
    case reminder
    case subtitle
    case tags
}

class PlantTableViewController: UIViewController {
    
    private var presenter: iPlantPresenter
    private var models: [(PlantModels, [String])] = []
    private var tags: [TagStruct] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FixedPlantTableViewCell.self, forCellReuseIdentifier: "\(FixedPlantTableViewCell.self)")
        tableView.register(ReminderButtonTableViewCell.self, forCellReuseIdentifier: "\(ReminderButtonTableViewCell.self)")
        tableView.register(ReminderTableViewCell.self, forCellReuseIdentifier: "\(ReminderTableViewCell.self)")
        tableView.register(TagTableViewCell.self, forCellReuseIdentifier: "\(TagTableViewCell.self)")
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "\(TitleTableViewCell.self)")
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(presenter: iPlantPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlantTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        switch model.0 {
        case .fixed:
            let fixedCell = tableView.dequeueReusableCell(withIdentifier: "\(FixedPlantTableViewCell.self)", for: indexPath) as! FixedPlantTableViewCell
            fixedCell.configureCell(date: model.1[0], description: model.1[1])
            return fixedCell
            
        case .reminderButton:
            let reminderButtonCell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderButtonTableViewCell.self)", for: indexPath) as! ReminderButtonTableViewCell
            reminderButtonCell.color = .myGreen
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
            
        case .tags:
            let tagsCell = tableView.dequeueReusableCell(withIdentifier: "\(TagTableViewCell.self)", for: indexPath) as! TagTableViewCell
            tagsCell.configure(tagsStruct: self.tags)
            return tagsCell
            
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension PlantTableViewController: iPlantView {
    func getTags(tagsStructs: [TagStruct]) {
        models.append((PlantModels.subtitle, ["Теги"]))
        models.append((PlantModels.tags, []))
        self.tags = tagsStructs
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        models.append((PlantModels.reminderButton, []))
        for reminder in remindersStruct {
            models.append((PlantModels.reminder, [reminder.reminderDate, reminder.reminderText]))
        }
    }
    
    
    func getFixedDates(fixedReminders: [ReminderStruct]) {
        for fixedReminder in fixedReminders {
            models.append((PlantModels.fixed, [fixedReminder.reminderDate, fixedReminder.reminderText]))
        }
    }
    
    func updateContent() {
        tableView.reloadData()
    }
    
    func getPlant(plant: String) {
        self.title = plant
    }
    
    
}
