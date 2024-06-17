//
//  DayScrollController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 15.05.2024.
//

import UIKit
import SnapKit

class DayScrollController: UIViewController {
    
    private var presenter: iDayPresenter
    private lazy var remindersViews: [RemindView] = []
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    lazy var tapReminderButton = UITapGestureRecognizer(target: self, action: #selector(handleReminderTap))
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private lazy var dateLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .titleFont
        dayLabel.textColor = .black
        return dayLabel
    }()
    
    private lazy var noteView: NoteView = {
        let noteView = NoteView()
        noteView.textViewDelegate = self
        return noteView
    }()
    
    private lazy var reminderButton = ReminderButton()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var plantsLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .subtitleFont
        dayLabel.textColor = .black
        dayLabel.text = "Растения"
        return dayLabel
    }()
    
    private lazy var plantCollectionView: TagCollectionView = {
        let collectionView = TagCollectionView()
        collectionView.tagCollectionDelegate = presenter
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGesture)
        presenter.viewDidLoad()
        setUp()
    }
    
    init(presenter: iDayPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayScrollController: iNoteView {
    
    func getDate(dateText: String) {
        dateLabel.text = dateText
    }
    
    func getNoteText(noteText: String) {
        noteView.text = noteText
    }
    
    func getReminders(remindersStruct: [ReminderStruct]) {
        remindersStruct.forEach({addReminderView(reminderStruct: $0)})
    }
    
    func addReminderView(reminderStruct: ReminderStruct) {
        let reminderView = RemindView()
        reminderView.time = reminderStruct.reminderTime
        reminderView.descriptionText = reminderStruct.reminderText
        remindersViews.append(reminderView)
        verticalStackView.addArrangedSubview(reminderView)
    }
    
    func getTags(tagsStruct: [TagStruct]) {
        plantCollectionView.tagsStruct = tagsStruct
    }
    
    
    func addTag(tagsStruct: TagStruct) {
        plantCollectionView.insert(newTag: tagsStruct)
    }
    
    func returnCurrentNoteText() -> String? {
        return noteView.text
    }
}

extension DayScrollController: UITextViewDelegate {
    //TODO: убрать сохранение по каждому тапу вне поля
    @objc func handleTap() {
        view.endEditing(true)
        presenter.viewEndedEditing()
    }
    
    @objc func handleReminderTap() {
        presenter.pressedAddReminderButton()
    }
}

extension DayScrollController {
    
    func setUp() {
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        reminderButton.addGestureRecognizer(tapReminderButton)
        
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
        
        [dateLabel, noteView, reminderButton, verticalStackView, plantsLabel, plantCollectionView].forEach { view in
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(20)
                make.width.equalToSuperview().inset(20)
            }
        }
        
        dateLabel.snp.makeConstraints({$0.top.equalToSuperview().inset(20)})
        noteView.snp.makeConstraints({$0.top.equalTo(dateLabel.snp.bottom).offset(20)})
        reminderButton.snp.makeConstraints({$0.top.equalTo(noteView.snp.bottom).offset(27)})
        verticalStackView.snp.makeConstraints({$0.top.equalTo(reminderButton.snp.bottom).offset(15)})
        plantsLabel.snp.makeConstraints({$0.top.equalTo(verticalStackView.snp.bottom).offset(25)})
        plantCollectionView.snp.makeConstraints({$0.top.equalTo(plantsLabel.snp.bottom).offset(10)})
        
        scrollView.snp.makeConstraints({$0.bottom.equalTo(plantCollectionView)})
    }
}
