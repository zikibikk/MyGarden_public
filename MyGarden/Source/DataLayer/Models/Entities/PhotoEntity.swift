//
//  PhotoEntity.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 04.06.2024.
//

import CoreData

@objc(PhotoEntity)
class PhotoEntity: NSManagedObject, EntityWithID {
    @NSManaged public var id: UUID
    @NSManaged public var path: String
    @NSManaged public var sha256: String
    @NSManaged public var plants: NSSet
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
}

extension PhotoEntity: Identifiable {}

extension PhotoEntity {

    @objc(addPlant:)
    func addPlant(plant: PlantEntity) {
        let plants = self.mutableSetValue(forKey: "plants")
        plants.add(plant)
    }

    @objc(removePlant:)
    func removePlant(plant: PlantEntity) {
        let plants = self.mutableSetValue(forKey: "plants")
        plants.remove(plant)
    }
}

extension PhotoEntity {
    func getInfo(photoStruct: PhotoStruct) {
        self.path = photoStruct.path
        self.sha256 = photoStruct.sha256
    }
}

struct PhotoStruct {
    var id: UUID
    public var path: String
    public var sha256: String
    public var plants: [UUID]
    
    init(id: UUID = UUID(), path: String, sha256: String, plants: [UUID] = []) {
        self.id = id
        self.path = path
        self.sha256 = sha256
        self.plants = plants
    }
    
    init(entity: PhotoEntity) {
        self.init(id: entity.id, path: entity.path, sha256: entity.sha256, plants: entity.plants.map({ ($0 as! PlantEntity).id }))
    }
}
