//
//  AirTimeViewController.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

final class AirTimeViewController: UIViewController, AirTimeView {
    final var presenter: AirTimePresenter
    
    init(presenter: AirTimePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
