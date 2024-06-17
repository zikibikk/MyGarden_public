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
    
    static var attentionRed: UIColor {
        return UIColor(red: 250/255, green: 115/255, blue: 131/255, alpha: 100)
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func decode(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

//MARK: - tag colors
extension UIColor {
    
    static var generateRandomColor: UIColor {
        var mask: [CGFloat] = [0, 1, 2]
        let max: CGFloat = 210
        let min: CGFloat = 237
        let randomMask = Int.random(in: 0...2)
        let randomValue = CGFloat.random(in: 210...237)
        let isFirstMinRandom = Bool.random()
        
        mask.remove(at: randomMask)
        
        if(isFirstMinRandom) {
            mask[0] = min
            mask[1] = max
        } else {
            mask[0] = max
            mask[1] = min
        }
        
        mask.insert(randomValue, at: randomMask)
        
        return UIColor(red: mask[0]/255, green: mask[1]/255, blue: mask[2]/255, alpha: 1)
    }
    
    static var tagGreen: UIColor {
        return UIColor(red: 204/255, green: 228/255, blue: 210/255, alpha: 1)
    }
    
    static var tagBlue: UIColor {
        return UIColor(red: 210/255, green: 221/255, blue: 237/255, alpha: 1)
    }
    
    static var tagPurple: UIColor {
        return UIColor(red: 214/255, green: 210/255, blue: 237/255, alpha: 1)
    }
    
    static var tagOrange: UIColor {
        return UIColor(red: 227/255, green: 199/255, blue: 172/255, alpha: 1)
    }
    
    static var tagYellow: UIColor {
        return UIColor(red: 236/255, green: 237/255, blue: 210/255, alpha: 1)
    }
    
    static var tagRed: UIColor {
        return UIColor(red: 237/255, green: 210/255, blue: 210/255, alpha: 1)
    }
}
