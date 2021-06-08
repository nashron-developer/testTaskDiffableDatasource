//
//  GridCollectionViewLayout.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 08.06.2021.
//

import UIKit

class GridCollectionViewLayout: UICollectionViewLayout {
    
    private let cellWidth: CGFloat = 200
    private let cellHeight: CGFloat = 50
    
    private let sectionHeaderWidth: CGFloat = 100
    private let sectionHeaderHeight: CGFloat = 50
    
    private var contentSize = CGSize.zero
    
    private var cellLayoutAttributes = [IndexPath:UICollectionViewLayoutAttributes]()
    private var headerLayoutAttributes = [Int:UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        contentSize
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
            contentSize = .zero
            return
        }
        (0 ..< collectionView.numberOfSections).forEach { section in
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            if numberOfItems > 0 {
                
                let xPos: CGFloat = 8
                let yPos = CGFloat(section) * sectionHeaderHeight + 8
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: xPos, y: yPos, width: sectionHeaderWidth, height: sectionHeaderHeight)
                headerLayoutAttributes[section] = attributes
                
                (0 ..< collectionView.numberOfItems(inSection: section)).forEach { item in
                    
                    let cellIndex = IndexPath(item: item, section: section)
                    let xPos = sectionHeaderWidth + 8 + CGFloat(item) * cellWidth + 8
                    let yPos = CGFloat(section) * cellHeight + 8
                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                    cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                    cellLayoutAttributes[cellIndex] = cellAttributes
                    
                }
            }
        }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        if numberOfItems > 0 {
            let contentHeight = CGFloat(collectionView.numberOfSections) * cellHeight
            let contentWidth = CGFloat(numberOfItems) * cellWidth
            self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cellLayoutAttributes.values.compactMap {  rect.intersects($0.frame) ? $0 : nil } + headerLayoutAttributes.values.compactMap { rect.intersects($0.frame) ? $0 : nil }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        headerLayoutAttributes[indexPath.section]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cellLayoutAttributes[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        false
    }
    
}
