//
//  ReminderViewCintroller.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 18.05.2024.
//

import UIKit
import SnapKit

class AddReminderController: UIViewController {
    
    private var service: iReminderService
    private var presenter: iReminderPresenter?
    private var delegate: addReminderDelegate
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .subtitleFont
        label.text = "Напоминание"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Введите текст напоминания"
        tf.borderStyle = .roundedRect
        tf.tintColor = .myGreen
        tf.keyboardType = .default
        tf.enablesReturnKeyAutomatically = true
        return tf
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.locale = .init(identifier: Locale.preferredLanguages.first!)
        return dp
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Поставить напоминание", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .subtitleFont
        button.backgroundColor = .myGreen
        return button
    }()
    
    private lazy var verticalView: UIStackView = {
        let hv = UIStackView()
        hv.axis = .vertical
        hv.spacing = 8
        return hv
    }()
    
    private lazy var reminderGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addReminder(_:)))
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }
    
    init(addReminderDelegate: addReminderDelegate) {
        self.delegate = addReminderDelegate
        self.service = ReminderService.shared
        super.init(nibName: nil, bundle: nil)
        presenter = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddReminderController {
    func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(verticalView)
        
        addButton.snp.makeConstraints({ $0.height.equalTo(50)})
        
        verticalView.snp.makeConstraints { maker in
            maker.left
                .right
                .equalToSuperview()
                .inset(15)
            maker.top.equalToSuperview()
                .inset(30)
        }
        
        verticalView.addArrangedSubview(titleLabel)
        verticalView.addArrangedSubview(textField)
        verticalView.addArrangedSubview(datePicker)
        verticalView.addArrangedSubview(addButton)
        addButton.addGestureRecognizer(reminderGestureRecognizer)
    }
}

extension AddReminderController {
    
    @objc func addReminder(_ sender:UITapGestureRecognizer) {
        guard let text = textField.text else { return }
        presenter?.pressedAddReminderButton(date: datePicker.date, text: text)
    }
}

extension AddReminderController: iReminderPresenter {
    func pressedAddReminderButton(date: Date, text: String) {
        if (!text.isEmpty) {
            guard let newReminder = service.saveReminder(date: date, text: text) else { return }
            delegate.addNewReminderToView(newStruct: newReminder)
            dismiss(animated: true)
        } else {
            textField.backgroundColor = .red
        }
    }
}
