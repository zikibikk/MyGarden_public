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
    
    //TODO: в фоновой очереди проверять
    func add(image: UIImage, toPlant plant: PlantStruct) -> PhotoStruct? {
        if let data = image.jpegData(compressionQuality: 1.0) {
            
            let shaToCompare = sha256(data: data)
            
            if plant.photos.map({$0.sha256}).contains(shaToCompare) { return nil }
            
            if let photoEntity = repository.fetch(withSha256: shaToCompare) {
                repository.add(photoWithID: photoEntity.id, toPlant: plant)
                return .init(entity: photoEntity)
            }
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let filename = url
//                .deletingLastPathComponent()
//                .deletingLastPathComponent()
//                .appendingPathComponent("plantsPhotos/\(UUID().uuidString).jpg")
            
            let filename = url
                .appendingPathComponent("\(UUID().uuidString).jpg")
            
            do {
                try data.write(to: filename)
                print("Image saved at: \(filename.path)")
            } catch {
                print("Failed to save image: \(error)")
                return nil
            }
            
            if let created = repository.create(photo: .init(path: filename.path, sha256: shaToCompare)) {
                let createdID = created.id
                repository.add(photoWithID: createdID, toPlant: plant)
                return .init(entity: created)
            } else {
                deleteFile(withURL: filename)
                return nil
            }
        }
        return nil
    }
    
    func get(fromPaths paths: [String]) -> [UIImage] {
        var result: [UIImage] = []
//        for path in paths {
//            if let img = loadImage(from: path) {result.append(img)}
//        }
        result.append(.demo1)
        result.append(.demo2)
        repository.deleteAll()
        var t = repository.fetchAll()
        return result
        
    }
}

private extension PhotoService {
    
    func sha256(data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func loadImage(from path: String) -> UIImage? {
            let url = URL(fileURLWithPath: path)
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path) {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) { return image }
                    else {
                        print("Failed to create UIImage from data.")
                        return nil
                    }
                } catch {
                    print("Failed to load data from URL: \(error)")
                    return nil
                }
            } else { print("File does not exist at path") }
        return nil
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
