//
//  ProgramsRepositoryTests.swift
//  TestTaskDiffableDatasourceTests
//
//  Created by Alexey Nikolaenko on 02.06.2021.
//

import XCTest
@testable import TestTaskDiffableDatasource

class ProgramsRepositoryTests: XCTestCase {

    var repository: ProgramsRepository!
    
    override func setUpWithError() throws {
        repository = ProgramsRepositoryImpl(baseUrl: ApiConfig.baseUrl)
    }

    override func tearDownWithError() throws {
        repository = nil
    }
    
    func testGetPrograms() throws {
        let expectation = expectation(description: "Load Programs")
        repository.getPrograms { result in
            switch result {
            case .success(let programs): XCTAssertFalse(programs.isEmpty)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30)
    }

}
