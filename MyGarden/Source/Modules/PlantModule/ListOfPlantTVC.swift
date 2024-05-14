//
//  PlantListTableViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.05.2024.
//

import UIKit
import SnapKit

class ListOfPlantTVC: UIViewController {
    
    private let presenter: iListOfPlantsPresenter
    private var plantNames: [String] = []
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .titleFont
        titleLabel.textColor = .black
        titleLabel.text = "Мой сад"
        return titleLabel
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
        plantNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = PlantTableViewCell()
        
        plant.text = plantNames[indexPath.row]
        
        return  plant
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedPlant(plant: plantNames[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListOfPlantTVC: iListOfPlantsView {
    func getListOfPlants(plantsNames: [String]) {
        self.plantNames = plantsNames
    }
}

extension ListOfPlantTVC {
    func setUp() {
        self.view.backgroundColor = .lightGreen
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalToSuperview().inset(25)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(110)
            
        }
    }
}
