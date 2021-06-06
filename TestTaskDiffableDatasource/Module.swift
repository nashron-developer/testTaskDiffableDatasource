//
//  Module.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

protocol Module: AnyObject{
    func getEntry() -> UIViewController
}
