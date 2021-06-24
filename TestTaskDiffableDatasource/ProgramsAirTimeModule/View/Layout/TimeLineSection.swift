//
//  TimeLineSection.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 08.06.2021.
//

import Foundation


final class TimeLineSection: CollectionSection {
    
    private(set) var times = [CollectionItem]()
    
    init(startTime: Date, endTime: Date, step: TimeInterval) {
        super.init(id: UUID().uuidString, title: "")
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d MMM"
        var tempDays = Set<String>()
        var tempDate = startTime
        while tempDate <= endTime {
            let dayString = dayFormatter.string(from: tempDate)
            if tempDays.insert(dayString).inserted {
                times.append(CollectionItem(label: "\(dayString)\n\(timeFormatter.string(from: tempDate))"))
            } else {
                times.append(CollectionItem(label: timeFormatter.string(from: tempDate)))
            }
            tempDate += step
        }
    }
    
}



