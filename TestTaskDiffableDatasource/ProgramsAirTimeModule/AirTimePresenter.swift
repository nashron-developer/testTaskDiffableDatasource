//
//  AirTimePresenter.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

protocol AirTimeView: AnyObject {
    var presenter: AirTimePresenter { get }
    
    func showAlert(with title: String, _ message: String?)
}

protocol AirTimePresenter {
    var view: AirTimeView? { get }
    
    func getAirTimeSections(completionHandler: @escaping ([AirTimeViewController.Section]) -> Void)
}

final class AirTimePresenterImpl: AirTimePresenter {
    
    weak var view: AirTimeView?
    private let interactor: AirTimeInteractor
    private let router: AirTimeRouter
    
    init(interactor: AirTimeInteractor, router: AirTimeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func getAirTimeSections(completionHandler: @escaping ([AirTimeViewController.Section]) -> Void) {
        interactor.getRecentAirTime { [weak view] (result) in
            
            switch result {
            case .success(let resentAirTime):
                let sections = resentAirTime.map { AirTimeViewController.Section(channel: $0, programs: $1)}
                DispatchQueue.main.async {
                    completionHandler(sections)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    view?.showAlert(with: "Error", error.localizedDescription)
                }
                
            }
        }
    }
    
}
