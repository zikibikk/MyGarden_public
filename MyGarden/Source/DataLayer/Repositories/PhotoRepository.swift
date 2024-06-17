//
//  PhotoRepository.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 05.06.2024.
//

import UIKit
import CoreData

class PhotoRepository {
    private let repository = Repository<PhotoEntity>()
    
    public static let shared = PhotoRepository()
    private init(){
        backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
    }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext?
    
    public func create(photo: PhotoStruct) -> PhotoEntity? {
        return repository.create(entitySetUp: { entity in
            entity.getInfo(photoStruct: photo)
        }, backgroundContext: backgroundContext!)
    }
    
    public func fetchAll() -> [PhotoEntity] {
        return repository.fetchAll(backContext: backgroundContext!)
    }
    
    public func fetch(withPath path: String) -> PhotoEntity? {
        return repository.fetchWith(predicate: "path", value: path, backgroundContext: backgroundContext!)
    }
    
    public func fetch(withSha256 sha256: String) -> PhotoEntity? {
        return repository.fetchWith(predicate: "sha256", value: sha256, backgroundContext: backgroundContext!)
    }
    
    public func deleteAll() {
        repository.deleteAll(backgroundContext: backgroundContext!)
    }
    
    
    public func add(photoWithID: UUID, toPlant plant: PlantStruct) {
        repository.manipulateEntityToEntity(addStruct: plant.id, toStruct: photoWithID, add: PlantEntity.self, to: PhotoEntity.self, backContext: backgroundContext!) { manipulating, target in
            target.addPlant(plant: manipulating)
        }
    }
    
    public func remove(photoWithID: UUID, fromPlant plant: PlantStruct) {
        repository.manipulateEntityToEntity(addStruct: plant.id, toStruct: photoWithID, add: PlantEntity.self, to: PhotoEntity.self, backContext: backgroundContext!) { manipulating, target in
            target.removePlant(plant: manipulating)
        }
    }
    
}
