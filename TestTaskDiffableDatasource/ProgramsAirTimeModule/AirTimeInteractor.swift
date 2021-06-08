//
//  AirTimeInteractor.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import Foundation

protocol AirTimeInteractor {
    func getPrograms(completionHandler: @escaping (Result<[Program], Error>) -> Void)
}

final class AirTimeInteractorImpl: AirTimeInteractor {
    
    private let programsRepository: ProgramsRepository
    private let channelsRepository: ChannelsRepository
    
    private var programs: [Program]?
    private var programsLastRequestTime: Date?
    
    init(programsRepository: ProgramsRepository, channelsRepository: ChannelsRepository) {
        self.channelsRepository = channelsRepository
        self.programsRepository = programsRepository
    }
    
    func getPrograms(completionHandler: @escaping (Result<[Program], Error>) -> Void) {
        if let programs = self.programs,
           let lastRequestTime = self.programsLastRequestTime,
           lastRequestTime.distance(to: Date()) < 300 {
            completionHandler(.success(programs))
            return
        }
        programsRepository.getPrograms(completionHandler: completionHandler)
    }
    
}
