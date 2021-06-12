//
//  CollectionSection.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 12.06.2021.
//

import Foundation

class CollectionSection: Identifiable, Hashable {
    
    final let id: String
    final let title: String
    
    init(id: String, title: String = "") {
        self.id = id
        self.title = title
    }
    
    static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}
