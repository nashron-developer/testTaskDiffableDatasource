//
//  Channel.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 02.06.2021.
//

import Foundation

struct Channel: Hashable {
    let id: Int
    let orderNum: Int
    let accessNum: Int
    let callSign: String
}

extension Channel: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case orderNum
        case accessNum
        case callSign = "CallSign"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        orderNum = try container.decode(Int.self, forKey: .orderNum)
        accessNum = try container.decode(Int.self, forKey: .accessNum)
        callSign = try container.decode(String.self, forKey: .callSign)
    }

}


