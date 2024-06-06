//
//  PhotosService.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 05.06.2024.
//

import UIKit
import CommonCrypto

class PhotoService {
    private let repository = PhotoRepository.shared
    
    public static let shared = PhotoService()
    private init(){ }
    
    func add(image: UIImage, toPlant plant: PlantStruct) -> Bool {
//        repository.fetch(withSha256: photo.)
//        PlantService.shared.
        //1 - нет ли уже этой фотографии у растения
        //2 - нет ли уже этой фотографии в базе
        
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            
            let shaToCompare = sha256(data: data)
            
            if plant.photos.map({$0.sha256}).contains(shaToCompare) { return false }
            
            if let photoEntity = repository.fetch(withSha256: shaToCompare) {
                //add photoEntity to plant
                return true
            }
            
            
            //TODO: раскомментировать сохранение в файлы
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filename = path.appendingPathComponent(UUID().uuidString + ".jpg")
            try? data.write(to: filename)
            
            if let createdID = repository.create(photo: .init(id: UUID(), path: filename.absoluteString, sha256: shaToCompare))?.id {
                repository.add(photoWithID: createdID, toPlant: plant)
                return true
            } else {
                deleteFile(withURL: filename)
                return false
            }
            
            inputView?.add(image: image)
            imageData.append(dataToCompare)
//            service.create(photoStruct: .init(id: UUID(), path: filename.path, plants: []))
        }
    }
}

private extension PhotoService {
    
    func loadImage(from path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func sha256(data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func cleanFileStorege() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
                print("Deleted file at: \(fileURL)")
            }
            print("\(fileURLs.count).")
        } catch {
            print("Failed to delete files: \(error)")
        }
    }
    
    func deleteFile(withURL url: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
            print("Deleted file at: \(url)")
        } catch {
            print("Failed to delete files: \(error)")
        }
    }
}
