//
//  FertilizerTableViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.06.2024.
//

import UIKit
import SnapKit

struct FertilizerStruct {
    var name: String
}

protocol iFertilizersListPresenter {
    var inputView: iFertilizersTableView? { get set }
    
    func viewWillAppear()
    func viewDidLoad()
    func selectedFertilizer(fertilizer: FertilizerStruct)
    func createFertilizer()
}

protocol iFertilizersTableView: UIViewController {
    func getListOfFertilizers(fertilizers: [FertilizerStruct])
}

class FertilizerTableViewController: UIViewController {
    
    lazy var tapPlusHandler = UITapGestureRecognizer(target: self, action: #selector (addFertilizer))
    
    private let presenter: iFertilizersListPresenter
    private var fertilizers: [FertilizerStruct] = []
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .titleFont
        titleLabel.textColor = .black
        titleLabel.text = "Мои удобрения"
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
        tableView.separatorColor = .tagBlue
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
    
    init(presenter: iFertilizersListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FertilizerTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fertilizers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fertilizer = PlantTableViewCell()
        fertilizer.text = fertilizers[indexPath.row].name
        return  fertilizer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedFertilizer(fertilizer: fertilizers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
//        presenter.selectedFertilizer(fertilizer: .init(name: "люкс"))
    }
}

extension FertilizerTableViewController: iFertilizersTableView {
    func getListOfFertilizers(fertilizers: [FertilizerStruct]) {
        self.fertilizers = fertilizers
    }
}

extension FertilizerTableViewController {
    @objc func addFertilizer() {
        presenter.createFertilizer()
    }
}

extension FertilizerTableViewController {
    func setUp() {
        self.view.backgroundColor = .tagBlue
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
