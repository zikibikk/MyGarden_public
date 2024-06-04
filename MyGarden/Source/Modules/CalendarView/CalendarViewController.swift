//
//  CalendarViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.05.2024.
//

import UIKit

protocol iCalendarPresenter {
    
}

//class CalendarPresenter: iCalendarPresenter {
//    
//}

class CalendarViewController: UIViewController {
    private var presenter: iCalendarPresenter?
    
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
        navigationItem.title = ""
        setUp()
    }
    
    init(presenter: iCalendarPresenter?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let dateToPresent = calendarView.calendar.date(from: dateComponents!)
        navigationController?.pushViewController(DayAssembly.assemble(forDate: dateToPresent!), animated: true)
    }
}

extension CalendarViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        
    }
}


extension CalendarViewController {
    func setUp() {
        view.backgroundColor = .white
        view.addSubview(calendarView)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
        }
    }
}
