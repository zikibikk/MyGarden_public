//
//  NoteCoreDataModel.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 11.05.2024.
//

import Foundation
import CoreData

@objc(NoteEntity)
public class NoteEntity: NSManagedObject {
    @NSManaged public var id: Int16
    @NSManaged public var text: String
    @NSManaged public var date: Date
//    @NSManaged public var plant:
    
    func getInfo(note: NoteStruct) {
        self.text = note.text
        self.date = note.date
    }
}

extension NoteEntity: Identifiable {}


public struct NoteStruct {
    var id: Int16
    var text: String
    var date: Date
}
