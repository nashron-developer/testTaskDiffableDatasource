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
    func showAlert(with title: String, _ message: String?, actions: [UIAlertAction])
}

protocol AirTimePresenter {
    var view: AirTimeView? { get }
    
    var earlierProgramTime: Date? { get }
    func getAirTimeSections(completionHandler: @escaping ([CollectionSection]) -> Void)
}

final class AirTimePresenterImpl: AirTimePresenter {
    
    weak var view: AirTimeView?
    private let interactor: AirTimeInteractor
    private let router: AirTimeRouter
    
    var earlierProgramTime: Date?
    
    init(interactor: AirTimeInteractor, router: AirTimeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func getAirTimeSections(completionHandler: @escaping ([CollectionSection]) -> Void) {
        interactor.getRecentAirTime { [weak self] (result) in
            switch result {
            case .success(let resentAirTime):
                let channelSections = resentAirTime
                    .map { ChannelSection(channel: $0, programs: $1)}
                    .sorted { $0.channel.orderNum < $1.channel.orderNum }
                let programs = channelSections
                    .flatMap { $0.programs }
                var sections = [CollectionSection]()
                if let earlier = programs.min(by: { $0.startTime < $1.startTime }),
                   let latest = programs.max(by: { ($0.startTime + TimeInterval($0.length * 60)) < ($1.startTime + TimeInterval($1.length * 60)) }) {
                    self?.earlierProgramTime = earlier.startTime
                    sections.append(
                        TimeLineSection(startTime: earlier.startTime, endTime: latest.startTime + TimeInterval(latest.length * 60), step: 30 * 60)
                    )
                }
                sections.append(contentsOf: channelSections)
                DispatchQueue.main.async {
                    completionHandler(sections)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(with: "Error", error.localizedDescription)
                }
                
            }
        }
    }
    
}
