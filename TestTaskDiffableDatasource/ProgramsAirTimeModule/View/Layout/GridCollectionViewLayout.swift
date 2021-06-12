//
//  GridCollectionViewLayout.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 08.06.2021.
//

import UIKit

final class GridCollectionViewLayout: UICollectionViewLayout {
    
    private let cellWidth: CGFloat = 200
    private let cellHeight: CGFloat = 60
    
    private let sectionHeaderWidth: CGFloat = 100
    private let sectionHeaderHeight: CGFloat = 60
    
    private var contentSize = CGSize.zero
    
    private var cellLayoutAttributes = [IndexPath:UICollectionViewLayoutAttributes]()
    private var headerLayoutAttributes = [Int:UICollectionViewLayoutAttributes]()
    
    final var cellPositionProvider: ((IndexPath) -> (CGFloat, CGFloat))!
    
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
        
        var contentHeight: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        (0 ..< collectionView.numberOfSections).forEach { section in
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            if numberOfItems > 0 {
                
                if section != 0 {
                    let xPos: CGFloat = 0
                    let yPos = CGFloat(section) * sectionHeaderHeight
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                    attributes.frame = CGRect(x: xPos, y: yPos, width: sectionHeaderWidth, height: sectionHeaderHeight)
                    headerLayoutAttributes[section] = attributes
                }
                
                var previousWidth: CGFloat =  sectionHeaderWidth
                contentHeight += cellHeight
                
                (0 ..< collectionView.numberOfItems(inSection: section)).forEach { item in
                    
                    let cellIndex = IndexPath(item: item, section: section)
                    let cellPosition = cellPositionProvider(cellIndex)
                    if previousWidth == sectionHeaderWidth {
                        previousWidth += cellPosition.0
                    }
                    let xPos = previousWidth
                    let yPos = CGFloat(section) * cellHeight
                    let cellWidth = cellPosition.1
                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                    cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                    cellLayoutAttributes[cellIndex] = cellAttributes
                    previousWidth = xPos + cellWidth
                }
                
                contentWidth = max(previousWidth, contentWidth)
            }
        }
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
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
