//
//  ChannelSection.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 12.06.2021.
//

import Foundation

final class ChannelSection: CollectionSection {

    final let channel: Channel
    final let programs: [Program]
    
    init(channel: Channel, programs: [Program]) {
        self.channel = channel
        self.programs = programs
        super.init(id: String(channel.id), title: channel.callSign)
    }
    
    static func == (lhs: ChannelSection, rhs: ChannelSection) -> Bool {
        lhs.channel.id == lhs.channel.id
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(channel.hashValue)
    }
    
}
