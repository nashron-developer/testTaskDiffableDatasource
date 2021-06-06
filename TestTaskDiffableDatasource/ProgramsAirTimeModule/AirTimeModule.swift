//
//  AirTimeModule.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

final class AirTimeModule: Module {
    
    private let viewController: AirTimeViewController
    
    init(programsRepository: ProgramsRepository, channelsRepository: ChannelsRepository) {
        let interactor = AirTimeInteractorImpl(programsRepository: programsRepository, channelsRepository: channelsRepository)
        let router = AirTimeRouterImpl()
        let presenter = AirTimePresenterImpl(interactor: interactor, router: router)
        viewController = AirTimeViewController(presenter: presenter)
        presenter.view = viewController
        router.entry = viewController
    }
    
    func getEntry() -> UIViewController {
        viewController
    }
}
