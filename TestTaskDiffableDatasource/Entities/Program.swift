//
//  Program.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 02.06.2021.
//

import Foundation

struct Program: Codable {
    let recentAirTime: RecentAirTime
    let name: String
    let shortName: String
    let startTime: String
    let length: Int
    
}
