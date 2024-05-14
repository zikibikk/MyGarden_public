//
//  DayVeiwController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 05.04.2024.
//

import UIKit
import SnapKit

class DayTableView: UITableViewController {
    
    private let dayPresenter: iDayPresenter
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .titleFont
        dayLabel.textColor = .black
        return dayLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(dayPresenter: iDayPresenter) {
        self.dayPresenter = dayPresenter
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayTableView {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: // label
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath) 
            noteCell.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(25)
                make.top.equalToSuperview().inset(40)
            }
            return noteCell
        default:
            return UITableViewCell()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
}

extension DayTableView: iNoteView {
    func getTags(tagsStruct: [TagStruct]) {
        
    }
    
    func updateContent() {
        
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        
    }
    
    func getDate(dateText: String) {
        dayLabel.text = dateText
    }
    
    func getNoteText(noteText: String) {
//        noteView.text = noteText
    }
    
    func getMockReminders(reminders: [String]) {
//        for reminderText in reminders {
//            self.reminders.append({
//                let newView = RemindView()
//                newView.descriptionText = reminderText
//                return newView
//            }())
//        }
    }
    
    func returnCurrentNoteText() -> String? {
        return "noteView.text"
    }
}


class DayViewController: UIViewController {
    
    private let notePresenter: iDayPresenter
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .titleFont
        dayLabel.textColor = .black
        return dayLabel
    }()
    
    private lazy var noteView = NoteView()
    
    private lazy var reminderButton = ReminderButton()
    
    //TODO: add getting reminders to protocol
    private lazy var reminders: [RemindView] = []
    
    //TODO: add getting plants to protocol
    private lazy var plants: [TagView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notePresenter.viewWillAppear()
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notePresenter.viewWillDisapear()
    }
    
    init(notePresenter: iDayPresenter) {
        self.notePresenter = notePresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayViewController {
    func setUp() {
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.addSubview(dayLabel)
        scrollView.addSubview(noteView)
        scrollView.addSubview(reminderButton)
        scrollView.alwaysBounceVertical = true

        scrollView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            maker.left.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(40)
        }
        
        noteView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
        }
        
        reminderButton.snp.makeConstraints { make in
            make.top.equalTo(noteView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
        }
        
        for reminderView in reminders {
            reminderView.snp.makeConstraints { make in
                
            }
        }
    }
}

extension DayViewController: iNoteView {
    func getTags(tagsStruct: [TagStruct]) {
        
    }
    
    func updateContent() {
        
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        
    }
    
    func getDate(dateText: String) {
        dayLabel.text = dateText
    }
    
    func getNoteText(noteText: String) {
        noteView.text = noteText
    }
    
    func getMockReminders(reminders: [String]) {
        for reminderText in reminders {
            self.reminders.append({
                let newView = RemindView()
                newView.descriptionText = reminderText
                return newView
            }())
        }
    }
    
    func returnCurrentNoteText() -> String? {
        return noteView.text
    }
}
