//
//  PhotosViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 05.06.2024.
//

enum PhotoAssemble {
    static func assembly(plant: PlantStruct) -> iPhotoView {
        let presenter = PhotosPresenter(plant: plant)
        let controller = PhotosViewController(presenter: presenter)
        presenter.inputView = controller
        return controller
    }
}

import UIKit

class PhotosViewController: UIViewController {
    
    private let presenter: iPhotoPresenter
    private var isRecognizing = false
    
    var images: [UIImage] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 170)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .myGreen
        button.setTitle("Добавить фото", for: .normal)
        button.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        return button
    }()
    
    private let recognizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.setTitle("Распознать заболевание", for: .normal)
        button.addTarget(self, action: #selector(recognizePhotoTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    init(presenter: iPhotoPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotosViewController: iPhotoView {
    
    func get(images: [UIImage]) {
        self.images = images
    }
    
    func add(image: UIImage) {
        self.images.append(image)
        collectionView.reloadData()
    }
    
    @objc func addPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        isRecognizing = false
    }
    
    @objc func recognizePhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        isRecognizing = true
    }
}
    
extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            if(!images.contains(image)) {
                let i = info[.imageURL] //TODO: передавать путь сразу здесь, а не мозги с фм делать
//                TODO: а в случае отсутствия файла по пути удалять сущность
                if(isRecognizing) {
                    presenter.imagePicker(recognizeItem: image)
                } else {
                    presenter.imagePicker(didSelectItem: image)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.collectionView(didSelectItem: images[indexPath.item])
    }
}

extension PhotosViewController {
    func setUp() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
//        collectionView.frame = view.bounds
        
        
        
        view.addSubview(addButton)
        view.addSubview(recognizeButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(recognizeButton.snp.top)
            make.centerX.equalToSuperview()
        }
        
        recognizeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(addButton.snp.top)
        }
    }
}
    

