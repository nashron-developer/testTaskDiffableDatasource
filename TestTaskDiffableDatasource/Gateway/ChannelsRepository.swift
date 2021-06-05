//
//  ChannelsRepository.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 02.06.2021.
//

import Foundation

protocol ChannelsRepository {
    func getChannels(completionHandler: @escaping (Result<[Channel], Error>) -> Void)
}

final class ChannelsRepositoryImpl: ChannelsRepository {
    
    private let requestUrl: URL
    
    init(baseUrl: URL) {
        guard let requestUrl = URL(string: "json/Channels", relativeTo: baseUrl) else {
            fatalError("Error to make url with baseUrl \(baseUrl.absoluteString) and path json/Channels")
        }
        self.requestUrl = requestUrl
    }
    
    final func getChannels(completionHandler: @escaping (Result<[Channel], Error>) -> Void) {
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
                let channels = try JSONDecoder().decode([Channel].self, from: data)
                completionHandler(.success(channels))
            } catch let exception {
                completionHandler(.failure(exception))
            }
        }.resume()
    }
    
}


