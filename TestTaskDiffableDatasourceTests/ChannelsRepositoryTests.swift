//
//  ChannelsRepositoryTests.swift
//  TestTaskDiffableDatasourceTests
//
//  Created by Alexey Nikolaenko on 02.06.2021.
//

import XCTest
@testable import TestTaskDiffableDatasource

class ChannelsRepositoryTests: XCTestCase {

    var repository: ChannelsRepository!
    
    override func setUpWithError() throws {
        repository = ChannelsRepositoryImpl(baseUrl: ApiConfig.baseUrl)
    }

    override func tearDownWithError() throws {
        repository = nil
    }
    
    func testGetChannels() throws {
        let expectation = expectation(description: "Load Channels")
        repository.getChannels { result in
            switch result {
            case .success(let channels): XCTAssertFalse(channels.isEmpty)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30)
    }

}
