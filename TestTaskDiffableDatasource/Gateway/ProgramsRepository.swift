//
//  ProgramsRepository.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 05.06.2021.
//

import Foundation

protocol ProgramsRepository {
    func getPrograms(completionHandler: @escaping (Result<[Program], Error>) -> Void)
}

final class ProgramsRepositoryImpl: ProgramsRepository {
    
    private let requestUrl: URL
    
    init(baseUrl: URL) {
        guard let requestUrl = URL(string: "json/ProgramItems", relativeTo: baseUrl) else {
            fatalError("Error to make url with baseUrl \(baseUrl.absoluteString) and path json/ProgramItems")
        }
        self.requestUrl = requestUrl
    }
    
    final func getPrograms(completionHandler: @escaping (Result<[Program], Error>) -> Void) {
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(ResponseError.dataIsNull))
                return
            }
            do {
                let programs = try JSONDecoder().decode([Program].self, from: data)
                completionHandler(.success(programs))
            } catch let exception {
                completionHandler(.failure(exception))
            }
        }.resume()
    }
    
}



