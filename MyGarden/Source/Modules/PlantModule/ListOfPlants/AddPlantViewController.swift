//
//  AddPlantViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 04.06.2024.
//

protocol addPlantDelegate {
    func getPlant(name: String)
}

import UIKit
import SnapKit

class AddPlantViewController: UIViewController {
    
    private var delegate: addPlantDelegate
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .subtitleFont
        label.text = "Новое растение"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Введите название растения"
        tf.borderStyle = .roundedRect
        tf.tintColor = .myGreen
        tf.keyboardType = .default
        tf.enablesReturnKeyAutomatically = true
        return tf
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .subtitleFont
        button.backgroundColor = .myGreen
        return button
    }()
    
    //TODO: распознание растения добавить здесь
    private lazy var recognizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Распознать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .subtitleFont
        button.backgroundColor = .tagBlue
        return button
    }()
    
    private lazy var verticalView: UIStackView = {
        let hv = UIStackView()
        hv.axis = .vertical
        hv.spacing = 8
        return hv
    }()
    
    private lazy var reminderGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPlant(_:)))
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }
    
    init(delegate: addPlantDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddPlantViewController {
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
        verticalView.addArrangedSubview(addButton)
        verticalView.addArrangedSubview(recognizeButton)
        addButton.addGestureRecognizer(reminderGestureRecognizer)
    }
}

extension AddPlantViewController {
    
    @objc func addPlant(_ sender:UITapGestureRecognizer) {
        guard let text = textField.text else { return }
        if (text.isEmpty) {
            Animations.fillBackground(view: textField, toColor: .attentionRed)
        } else {
            delegate.getPlant(name: text)
        }
    }
}
