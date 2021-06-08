//
//  CollectionViewSection.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 08.06.2021.
//

import Foundation

extension AirTimeViewController {
    
    final class Section: Hashable {
        
        var channel: Channel
        var programs: [Program]
        
        init(channel: Channel, programs: [Program]) {
            self.channel = channel
            self.programs = programs
        }
        
        static func == (lhs: Section, rhs: Section) -> Bool {
            lhs.channel.id == lhs.channel.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(channel.hashValue)
        }
        
    }
    
}
