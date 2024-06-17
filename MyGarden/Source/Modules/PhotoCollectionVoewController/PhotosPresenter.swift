//
//  PhotosPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 05.06.2024.
//

import UIKit
import SnapKit
import CoreML
import Vision

protocol iPhotoView: UIViewController {
    func get(images: [UIImage])
    func add(image: UIImage)
}

protocol iPhotoPresenter {
    var inputView: iPhotoView? { get set }
    func viewDidLoad()
    func imagePicker(didSelectItem item: UIImage)
    func imagePicker(recognizeItem item: UIImage)
    func collectionView(didSelectItem item: UIImage)
}

protocol iPhotablePresenter {
    func photoImagePressed()
}

class PhotosPresenter: iPhotoPresenter {
    
    weak var inputView: iPhotoView?
    var imageData: [String] = []
    private let service = PhotoService.shared
    private var plant: PlantStruct
    private var model: VNCoreMLModel?
    
    func viewDidLoad() {
        guard let plant = PlantService.shared.get(plantWithID: plant.id) else {return}
        inputView?.get(images: service.get(fromPaths: plant.photos.map({$0.path})))
    }
    
    init(plant: PlantStruct) {
        self.plant = plant
//        let configuration = MLModelConfiguration()
//        configuration.computeUnits = .all
//        configuration.allowLowPrecisionAccumulationOnGPU = true
//        do {
//            print(PlantDisease_1.urlOfModelInThisBundle)
//            let model = try VNCoreMLModel(for: PlantDisease_1(configuration: configuration).model)
//            self.model = model
//        } catch {
//            print("Ошибка инициализации модели: \(error)")
//        }
    }
    
    func imagePicker(didSelectItem item: UIImage) {
        if let photo = service.add(image: item, toPlant: plant) {
            inputView?.add(image: item)
            plant.photos.append(photo)
        }
    }
    
    func imagePicker(recognizeItem item: UIImage) {
//        recognizeDisease(from: item)
        showImage(image: item, description: "Мучнистая роса, 100%")
    }
    
    
    func collectionView(didSelectItem item: UIImage) {
        showImage(image: item)
    }
}

extension PhotosPresenter {
    
    private func showImage(image: UIImage, description: String = "") {
        let testController = UIViewController()
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        
        lazy var descriptionLabel: UILabel = {
            let descriptionLabel = UILabel()
            descriptionLabel.font = .noteFont
            descriptionLabel.textColor = .white
            descriptionLabel.text = description
            return descriptionLabel
        }()
        
        testController.view.backgroundColor = .init(white: 0, alpha: 0.5)
        testController.view.addSubview(iv)
        testController.view.addSubview(descriptionLabel)
        
        iv.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(30)
            make.height.lessThanOrEqualToSuperview().inset(30)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iv.snp.bottom).offset(20)
        }
        
        inputView?.present(testController, animated: true)
    }
    
    private func recognizeDisease(from image: UIImage) {

        let configuration = MLModelConfiguration()
        configuration.computeUnits = .all
        configuration.allowLowPrecisionAccumulationOnGPU = true
        do {
            let model = try VNCoreMLModel(for: PlantDisease_1(configuration: configuration).model)
        } catch {
            print("Ошибка инициализации модели: \(error)")
        }
        
        guard let cgImage = image.cgImage else { return }
        
        let request = VNCoreMLRequest(model: model!) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            for classification in results {
                print("\(classification.identifier): \(classification.confidence)")
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
}
