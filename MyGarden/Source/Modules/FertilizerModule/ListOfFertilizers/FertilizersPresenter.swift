//
//  FertilizersPresenter.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 14.06.2024.
//

import UIKit


class FertilizersPresenter: iFertilizersListPresenter {
    weak var inputView: iFertilizersTableView?
    
    
    func viewWillAppear() {
        inputView?.getListOfFertilizers(fertilizers: mockInfoArray)
    }
    
    func viewDidLoad() {
        inputView?.getListOfFertilizers(fertilizers: mockInfoArray)
    }
    
    func selectedFertilizer(fertilizer: FertilizerStruct) {
        let fertilizerDemo = UIViewController()
        fertilizerDemo.view = UIImageView(image: .fertilizer)
        fertilizerDemo.navigationItem.backButtonTitle = ""
        inputView?.navigationController?.pushViewController(fertilizerDemo, animated: true)
        fertilizerDemo.navigationController?.isNavigationBarHidden = false
    }
    
    func createFertilizer() {
        
    }
    
    
    let mockInfoArray: [FertilizerStruct] = [.init(name: "Гумат фосфора"), 
                                            .init(name: "Фертика люкс"),
                                             .init(name: "Осмокот")]
}
