//
//  AirTimeInteractor.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import Foundation

protocol AirTimeInteractor {
    func getRecentAirTime(completionHandler: @escaping (Result<[Channel:[Program]], Error>) -> Void)
}

final class AirTimeInteractorImpl: AirTimeInteractor {
    
    private let programsRepository: ProgramsRepository
    private let channelsRepository: ChannelsRepository
    
    private var resentAirTime: [Channel: [Program]]?
    private var programsLastRequestTime: Date?
    
    init(programsRepository: ProgramsRepository, channelsRepository: ChannelsRepository) {
        self.channelsRepository = channelsRepository
        self.programsRepository = programsRepository
    }
    
    func getRecentAirTime(completionHandler: @escaping (Result<[Channel : [Program]], Error>) -> Void) {
        if let resentAirTime = self.resentAirTime,
           let lastRequestTime = self.programsLastRequestTime,
           lastRequestTime.distance(to: Date()) < 300 {
            completionHandler(.success(resentAirTime))
            return
        }
        var programs = [Program]()
        var channels = [Channel]()
        let group = DispatchGroup()
        group.enter()
        programsRepository.getPrograms { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let responsePrograms): programs = responsePrograms
            case .failure(let error): completionHandler(.failure(error))
            }
        }
        group.enter()
        channelsRepository.getChannels { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let responseChannels): channels = responseChannels
            case .failure(let error): completionHandler(.failure(error))
            }
        }
        group.notify(queue: .global(qos: .userInitiated)) { [unowned self] in
            var resentAirTime = [Channel:[Program]]()
            channels.forEach { channel in
                let programsByChannel = programs.filter { $0.recentAirTime.channelID == channel.id }
                programs.removeAll(where: { programsByChannel.contains($0) })
                resentAirTime[channel] = programsByChannel
            }
            self.resentAirTime = resentAirTime
            completionHandler(.success(resentAirTime))
        }
    }

}
