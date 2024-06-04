//
//  Colors.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.03.2024.
//

import UIKit
import CoreData

extension UIColor {
    
    static var lightGreen: UIColor {
        return UIColor(red: 204/255, green: 228/255, blue: 210/255, alpha: 1)
    }
    
//    static var lightGreen: UIColor {
//        return UIColor(red: 78/255, green: 161/255, blue: 101/255, alpha: 0.29)
//    }
    
    static var myGreen: UIColor {
        return UIColor(red: 78/255, green: 161/255, blue: 101/255, alpha: 1)
    }
    
    static var noteTextGray: UIColor {
        return UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 100)
    }
    
    static var separatorGray: UIColor {
        return UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 100)
    }
    
    static var reminderGray: UIColor {
        return UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 100)
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func decode(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        
        NSSecureUnarchiveFromDataTransformer.classForKeyedUnarchiver()
    }
}
