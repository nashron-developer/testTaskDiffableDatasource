//
//  AirTimeViewController.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, Program>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Program>

class AirTimeViewController: UICollectionViewController, AirTimeView {
    final var presenter: AirTimePresenter
    
    init(presenter: AirTimePresenter) {
        self.presenter = presenter
        super.init(collectionViewLayout: GridLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getAirTimeSections { [weak self] sections in
            self?.applySnapshot(with: sections)
        }
    }
    
    private lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView) { (collectionView, indexPath, resentAirTime) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
            if let label = cell.contentView.subviews.first as? UILabel {
                label.text = resentAirTime.name
            } else {
                let label = UILabel(frame: .init(origin: .zero, size: .init(width: 200, height: 50)))
                label.numberOfLines = 0
                label.text = resentAirTime.name
                cell.contentView.addSubview(label)
            }
            return cell
        }
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let program = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print("did select program: #\(program.recentAirTime.id) \(program.name) on chanel: \(program.recentAirTime.channelID)")
    }
    
    func applySnapshot(with sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.programs, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func showAlert(with title: String, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Close", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
}

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

class GridLayout: UICollectionViewLayout {
    
    private let cellWidth: CGFloat = 200
    private let cellHeight: CGFloat = 50
    private var contentSize = CGSize.zero
    
    private var cellAttributes = [IndexPath:UICollectionViewLayoutAttributes]()
    
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
        
        // Cycle through each section of the data source.
        if (collectionView?.numberOfSections ?? 0) > 0 {
            for section in 0...collectionView!.numberOfSections - 1 {
                
                // Cycle through each item in the section.
                if collectionView!.numberOfItems(inSection: section) > 0 {
                    for item in 0...collectionView!.numberOfItems(inSection: section) - 1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = CGFloat(item) * cellWidth + 8
                        let yPos = CGFloat(section) * cellHeight + 8
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // Save the attributes.
                        self.cellAttributes[cellIndex] = cellAttributes
                        
                    }
                }
                
            }
        }
        
        // Update content size.
        if let numberOfSections = collectionView?.numberOfSections,
           numberOfSections > 0,
           let numberOfItems = collectionView?.numberOfItems(inSection: 0) {
            let contentHeight = CGFloat(numberOfSections) * cellHeight
            let contentWidth = CGFloat(numberOfItems) * cellWidth
            self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        } else {
            contentSize = .zero
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttributes.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cellAttributes[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        false
    }
    
}
