//
//  CalendarViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.05.2024.
//

import UIKit

protocol iCalendarPresenter {
    func viewDidLoad()
}

//class CalendarPresenter: iCalendarPresenter {
//    
//}

class CalendarViewController: UIViewController {
    private var presenter: iCalendarPresenter?
    private var selectedDates: [Date] = []
    private var isAddButtonAdded = false
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        
        calendarView.calendar = .current
        calendarView.locale = Locale(identifier: "ru_RU")
        calendarView.tintColor = .myGreen
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()
    
    private lazy var multiButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.init(systemName: "bell")!, for: .normal)
        button.setImage(.init(systemName: "bell.fill")!, for: .selected)
        button.tintColor = .myGreen
        return button
    }()
    
    private lazy var remindersLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .subtitleFont
        dayLabel.textColor = .black
        dayLabel.text = "Напоминания на сегодня:"
        return dayLabel
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Поставить напоминания", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .subtitleFont
        button.backgroundColor = .myGreen
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedToday()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        setUp()
    }
    
    init(presenter: iCalendarPresenter?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let dateToPresent = calendarView.calendar.date(from: dateComponents!)
        if (self.calendarView.calendar.isDateInToday(dateToPresent!)) {
            selectedToday()
        }
        else {
            navigationController?.pushViewController(DayAssembly.assemble(forDate: dateToPresent!), animated: true)
        }
        
        selection.setSelected(nil, animated: true)
    }
}

extension CalendarViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        guard let date = calendarView.calendar.date(from: dateComponents) else {return}
        selectedDates.append(date)
        showAddButton()
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        guard let date = calendarView.calendar.date(from: dateComponents) else {return}
        selectedDates.removeAll(where: {$0 == date})
        if (selectedDates.count == 0) { hideAddButon() }
    }
}

extension CalendarViewController: addReminderDelegate {
    func pressedAddReminderButton() {
        
    }
    
    func addNewReminderToView(newStruct: ReminderStruct) {
        for day in selectedDates {
            print(newStruct.reminderDateWithTime.timeIntervalSince(day))
            print(day.getDayWithWeekString() + day.getTime())
        }
        selectedDates.removeAll()
        multiButton.isSelected = !multiButton.isSelected
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        hideAddButon()
    }
}


extension CalendarViewController {
    
    @objc
    func addButtonPressed() {
        let addReminderController = AddReminderController(addReminderDelegate: self, timeMode: true)
        if let sheet = addReminderController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(addReminderController, animated: true)
    }
    
    @objc func buttonTapped() {
        multiButton.isSelected = !multiButton.isSelected
        if(multiButton.isSelected) {
            let dateSelection = UICalendarSelectionMultiDate(delegate: self)
            calendarView.selectionBehavior = dateSelection
        } else {
            let dateSelection = UICalendarSelectionSingleDate(delegate: self)
            calendarView.selectionBehavior = dateSelection
            hideAddButon()
        }
    }
    
    func showAddButton() {
        addButton.isHidden = false
        remindersLabel.isHidden = true
        verticalStackView.isHidden = true
    }
    
    func hideAddButon() {
        addButton.isHidden = true
        remindersLabel.isHidden = false
        verticalStackView.isHidden = false
    }
    
    func setUp() {
        view.backgroundColor = .white
        view.addSubview(calendarView)
        view.addSubview(multiButton)
        view.addSubview(remindersLabel)
        view.addSubview(verticalStackView)
        view.addSubview(addButton)
        
        multiButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
        }
        
        multiButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.left.equalTo(calendarView).inset(210)
        }
        
        multiButton.imageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(30)
        })
        
        remindersLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.left.equalTo(calendarView)
        }
        
        addButton.snp.makeConstraints { make in
            make.left.right.equalTo(calendarView)
            make.top.equalTo(calendarView.snp.bottom).offset(20)
        }
    }
    
    func selectedToday() {
        
        verticalStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        
        let reminders = ReminderService.shared.getRemindersForDate(date: Date())
        
        guard reminders.count > 0 else {
            remindersLabel.text = "На сегодня напоминаний нет"
            return
        }
        
        reminders.forEach { reminderStruct in
            let reminderView = RemindView()
            reminderView.time = reminderStruct.reminderTime
            reminderView.descriptionText = reminderStruct.reminderText
            verticalStackView.addArrangedSubview(reminderView)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(remindersLabel.snp.bottom).offset(10)
            make.left.right.equalTo(calendarView)
        }
    }
}
