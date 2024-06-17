//
//  PlantListTableViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.05.2024.
//

import UIKit
import SnapKit

class ListOfPlantTVC: UIViewController {
    
    lazy var tapPlusHandler = UITapGestureRecognizer(target: self, action: #selector (addPlant))
    
    private let presenter: iListOfPlantsPresenter
    private var plants: [PlantStruct] = []
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .titleFont
        titleLabel.textColor = .black
        titleLabel.text = "Мой сад"
        return titleLabel
    }()
    
    private lazy var plusImage: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 30
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGreen
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        presenter.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        presenter.viewDidLoad()
        setUp()
    }
    
    init(presenter: iListOfPlantsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListOfPlantTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = PlantTableViewCell()
        plant.text = plants[indexPath.row].name
        return  plant
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedPlant(plant: plants[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListOfPlantTVC: iListOfPlantsView {
    func getListOfPlants(plants: [PlantStruct]) {
        self.plants = plants
    }
}

extension ListOfPlantTVC {
    @objc func addPlant() {
        print("www")
        presenter.createPlant()
    }
}

extension ListOfPlantTVC {
    func setUp() {
        self.view.backgroundColor = .lightGreen
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(plusImage)
        
        plusImage.addGestureRecognizer(tapPlusHandler)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalToSuperview().inset(25)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(110)
            
        }
        
        plusImage.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(35)
            make.width.equalTo(35)
        }
    }
}
