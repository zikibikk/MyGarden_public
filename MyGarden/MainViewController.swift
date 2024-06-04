//
//  ViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 01.03.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        
        calendarView.calendar = .current
        calendarView.locale = Locale(identifier: "ru_RU")
        calendarView.tintColor = .myGreen
        calendarView.fontDesign = .rounded
        
        return calendarView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension MainViewController {
    func setUp() {
        view.backgroundColor = .white
        view.addSubview(calendarView)
        
        let dateSelection = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
        }
    }
}


extension MainViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        print(dateComponents)
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        print(dateComponents)
    }
}
