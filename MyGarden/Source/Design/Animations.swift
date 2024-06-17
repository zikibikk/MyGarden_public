//
//  Animations.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 03.06.2024.
//

import UIKit

enum Animations {
    static func fillBackground(view: UIView, toColor color: UIColor) {
        UIView.animate(withDuration: 0.3, animations: {
            view.backgroundColor = color
                }, completion: { _ in
                    // Вторая часть анимации - возврат к исходному цвету
                    UIView.animate(withDuration: 0.75, animations: { [view] in
                        view.backgroundColor = .white
                    })
                })
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
