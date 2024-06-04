//
//  PlantScrollViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 16.05.2024.
//

import UIKit

class PlantScrollViewController: UIViewController {
    private var presenter: iPlantPresenter
    private lazy var fixedDatesViews: [FixedDatesView] = []
    private lazy var remindersViews: [RemindView] = []
    
    lazy var tapReminderButton = UITapGestureRecognizer(target: self, action: #selector(handleReminderTap))
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private lazy var verticalFixedDatesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var reminderButton = ReminderButton()
    
    private lazy var verticalReminderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var tagsLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .subtitleFont
        dayLabel.textColor = .black
        dayLabel.text = "Теги"
        return dayLabel
    }()
    
    private lazy var tagCollectionView = TagCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
    
    init(presenter: iPlantPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlantScrollViewController: iPlantView {
    
    func getPlantName(_ plant: String) {
        self.title = plant
    }
    
    func getFixedDates(fixedReminders: [ReminderStruct]) {
        for fixedReminder in fixedReminders {
            addFixedDates(fixedReminder: fixedReminder)
        }
    }
    
    func addFixedDates(fixedReminder: ReminderStruct) {
        let reminderView = FixedDatesView()
        reminderView.date = fixedReminder.reminderDate
        reminderView.descriptionText = fixedReminder.reminderText
        fixedDatesViews.append(reminderView)
        verticalFixedDatesStackView.addArrangedSubview(reminderView)
    }
    
    func getTags(tagsStructs: [TagStruct]) {
        tagCollectionView.tagsStruct = tagsStructs
    }
}

extension PlantScrollViewController: remindableView {
    
    func addReminderView(reminderStruct: ReminderStruct) {
        let reminderView = RemindView()
        reminderView.time = reminderStruct.reminderTime
        reminderView.descriptionText = reminderStruct.reminderText
        remindersViews.append(reminderView)
        verticalReminderStackView.addArrangedSubview(reminderView)
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        for reminderStruct in remindersStruct {
            addReminderView(reminderStruct: reminderStruct)
        }
    }
}

extension PlantScrollViewController {
    @objc func handleReminderTap() {
        presenter.pressedAddReminderButton()
    }
}

extension PlantScrollViewController {
    func setUp() {
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        self.reminderButton.addGestureRecognizer(tapReminderButton)
        
        reminderButton.color = .myGreen
        
        scrollView.snp.makeConstraints { maker in
            maker.left
                .equalToSuperview()
            maker.width
                .equalTo(view.safeAreaLayoutGuide.snp.width)
            maker.top
                .equalToSuperview()
            maker.bottom
                .equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        [verticalFixedDatesStackView, reminderButton, verticalReminderStackView, tagsLabel, tagCollectionView].forEach { view in
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(20)
                make.width.equalToSuperview().inset(20)
            }
        }
        
        verticalFixedDatesStackView.snp.makeConstraints({$0.top.equalToSuperview().inset(20)})
        reminderButton.snp.makeConstraints({$0.top.equalTo(verticalFixedDatesStackView.snp.bottom).offset(30)})
        verticalReminderStackView.snp.makeConstraints({$0.top.equalTo(reminderButton.snp.bottom).offset(15)})
        tagsLabel.snp.makeConstraints({$0.top.equalTo(verticalReminderStackView.snp.bottom).offset(25)})
        tagCollectionView.snp.makeConstraints({$0.top.equalTo(tagsLabel.snp.bottom).offset(10)})
    }
}
