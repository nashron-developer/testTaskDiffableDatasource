//
//  AirTimeViewController.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

typealias AirTimeDataSource = UICollectionViewDiffableDataSource<AirTimeViewController.Section, Program>
typealias AirTimeSnapshot = NSDiffableDataSourceSnapshot<AirTimeViewController.Section, Program>

final class AirTimeViewController: UICollectionViewController, AirTimeView {
    final var presenter: AirTimePresenter
    
    init(presenter: AirTimePresenter) {
        self.presenter = presenter
        super.init(collectionViewLayout: GridCollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getAirTimeSections { [weak self] sections in
            self?.applySnapshot(with: sections)
        }
    }
    
    private lazy var dataSource: AirTimeDataSource = {
        let dataSource = AirTimeDataSource(collectionView: collectionView) { (collectionView, indexPath, resentAirTime) -> UICollectionViewCell? in
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
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier, for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.channel.CallSign
            return view
        }
        return dataSource
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let program = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print("did select program: #\(program.recentAirTime.id) \(program.name) on chanel: \(program.recentAirTime.channelID)")
    }
    
    func applySnapshot(with sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = AirTimeSnapshot()
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
