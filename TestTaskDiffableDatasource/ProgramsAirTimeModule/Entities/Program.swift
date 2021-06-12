//
//  Program.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 02.06.2021.
//

import Foundation

struct Program: Hashable, Codable {
    let recentAirTime: RecentAirTime
    let name: String
    let startTime: Date
    let length: Int
    
}
