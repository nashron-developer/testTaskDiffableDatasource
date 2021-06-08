//
//  SectionHeaderReusableView.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 08.06.2021.
//

import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 3
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        
        var constraints = [NSLayoutConstraint]()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraints += [
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,constant: -5)
            ]
        } else {
            constraints += [
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor)
            ]
        }
        constraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
