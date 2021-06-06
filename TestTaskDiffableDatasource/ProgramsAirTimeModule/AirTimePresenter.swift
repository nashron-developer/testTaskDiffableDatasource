//
//  AirTimePresenter.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

protocol AirTimeView: AnyObject {
    var presenter: AirTimePresenter { get }
}

protocol AirTimePresenter {
    var view: AirTimeView? { get }
}

final class AirTimePresenterImpl: AirTimePresenter {
    
    weak var view: AirTimeView?
    private let interactor: AirTimeInteractor
    private let router: AirTimeRouter
    
    init(interactor: AirTimeInteractor, router: AirTimeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
}
