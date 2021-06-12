//
//  CollectionItem.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 12.06.2021.
//

import Foundation

struct CollectionItem: Identifiable, Hashable {
    let id = UUID().uuidString
    let label: String
}
