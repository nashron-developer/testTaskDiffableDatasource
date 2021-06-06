//
//  AirTimeInteractor.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import Foundation

protocol AirTimeInteractor {
    
}

final class AirTimeInteractorImpl: AirTimeInteractor {
    
    private let programsRepository: ProgramsRepository
    private let channelsRepository: ChannelsRepository
    
    init(programsRepository: ProgramsRepository, channelsRepository: ChannelsRepository) {
        self.channelsRepository = channelsRepository
        self.programsRepository = programsRepository
    }
    
}
