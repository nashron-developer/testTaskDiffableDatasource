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
    
    func getPrograms(completionHandler: @escaping ([Program]) -> Void)
}

final class AirTimePresenterImpl: AirTimePresenter {
    
    weak var view: AirTimeView?
    private let interactor: AirTimeInteractor
    private let router: AirTimeRouter
    
    init(interactor: AirTimeInteractor, router: AirTimeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func getPrograms(completionHandler: @escaping ([Program]) -> Void) {
        interactor.getPrograms { [weak view] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let programs):
                    completionHandler(programs)
                case .failure(let error):
                    view?.showAlert(with: "Error", error.localizedDescription)
                }
            }
        }
    }
    
}
