//
//  PlantScrollViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 16.05.2024.
//

import UIKit
import SnapKit

class PlantScrollViewController: UIViewController {
    private var presenter: iPlantPresenter
    private lazy var fixedDatesViews: [FixedDatesView] = []
    private lazy var remindersViews: [RemindView] = []
    
    lazy var tapReminderButton = UITapGestureRecognizer(target: self, action: #selector(handleReminderTap))
    lazy var tapImageButton = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .titleFont
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private lazy var imagesButton: UIImageView = {
        let view =  UIImageView(image: UIImage(systemName: "photo.on.rectangle.angled"))
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        return view
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
    
    private lazy var tagCollectionView: TagCollectionView = {
        let collectionView = TagCollectionView()
        collectionView.tagCollectionDelegate = presenter
        return collectionView
    }()
    
    private lazy var fertilizersLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = .subtitleFont
        dayLabel.textColor = .black
        dayLabel.text = "Удобрения"
        return dayLabel
    }()
    
    private lazy var fertsCollectionView: TagCollectionView = {
        let collectionView = TagCollectionView()
        collectionView.tagCollectionDelegate = presenter
        collectionView.tagsStruct  = [.init(name: "Фертика люкс", color: .tagBlue)]
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
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
        titleLabel.text = plant
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
    
    func getTags(tagsStruct tagsStructs: [TagStruct]) {
        tagCollectionView.tagsStruct = tagsStructs
    }
    
    func addTag(tagsStruct: TagStruct) {
        tagCollectionView.insert(newTag: tagsStruct)
    }
    
}

extension PlantScrollViewController: remindableView {
    
    func addReminderView(reminderStruct: ReminderStruct) {
        let reminderView = RemindView()
        reminderView.time = reminderStruct.reminderDate + reminderStruct.reminderTime
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
    @objc func handleImageTap() {
        presenter.photoImagePressed()
    }
}

extension PlantScrollViewController {
    func setUp() {
        
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        self.reminderButton.addGestureRecognizer(tapReminderButton)
        self.imagesButton.addGestureRecognizer(tapImageButton)
        
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
        
        [verticalFixedDatesStackView, reminderButton, verticalReminderStackView, tagsLabel, tagCollectionView, fertilizersLabel, fertsCollectionView].forEach { view in
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(20)
                make.width.equalToSuperview().inset(20)
            }
        }
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imagesButton)
        
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        })
        
        imagesButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview().inset(300)
            make.width.equalTo(54)
            make.height.equalTo(44)
        }
        if fixedDatesViews.count == 0 {
            reminderButton.snp.makeConstraints({$0.top.equalTo(titleLabel.snp.bottom).offset(30)})
        }
        else {
            verticalFixedDatesStackView.snp.makeConstraints({$0.top.equalTo(titleLabel.snp.bottom).offset(20)})
            reminderButton.snp.makeConstraints({$0.top.equalTo(verticalFixedDatesStackView.snp.bottom).offset(30)})
        }
        verticalReminderStackView.snp.makeConstraints({$0.top.equalTo(reminderButton.snp.bottom).offset(15)})
        tagsLabel.snp.makeConstraints({$0.top.equalTo(verticalReminderStackView.snp.bottom).offset(25)})
        tagCollectionView.snp.makeConstraints({$0.top.equalTo(tagsLabel.snp.bottom).offset(10)})
        fertilizersLabel.snp.makeConstraints({$0.top.equalTo(tagCollectionView.snp.bottom).offset(25)})
        fertsCollectionView.snp.makeConstraints({$0.top.equalTo(fertilizersLabel.snp.bottom).offset(10)})
    }
}
