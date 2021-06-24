//
//  AirTimeViewController.swift
//  TestTaskDiffableDatasource
//
//  Created by Alexey Nikolaenko on 06.06.2021.
//

import UIKit

typealias AirTimeDataSource = UICollectionViewDiffableDataSource<CollectionSection, AnyHashable>
typealias AirTimeSnapshot = NSDiffableDataSourceSnapshot<CollectionSection, AnyHashable>

final class AirTimeViewController: UICollectionViewController {
    final var presenter: AirTimePresenter
    
    init(presenter: AirTimePresenter) {
        self.presenter = presenter
        let layout = GridCollectionViewLayout()
        super.init(collectionViewLayout: layout)
        
        layout.cellPositionProvider = { [weak self] (indexPath) in
            guard let model = self?.dataSource.itemIdentifier(for: indexPath) else {
                return (0, 0)
            }
            // Config cell width multiplayer
            let pointPerMinute: CGFloat = 10
            switch model {
            case is Program:
                let model = model as! Program
                var offset: CGFloat = 0
                if let earlyTime = self?.presenter.earlierProgramTime {
                    offset = CGFloat(earlyTime.distance(to: model.startTime)) / 60
                }
                return (offset * pointPerMinute, CGFloat(model.length) * pointPerMinute)
            default: return (0, 30 * pointPerMinute)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TimeCollectionViewCell")
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getAirTimeSections { [weak self] sections in
            self?.applySnapshot(with: sections)
        }
    }
    
    private lazy var dataSource: AirTimeDataSource = {
        let dataSource = AirTimeDataSource(collectionView: collectionView) {  (collectionView, indexPath, model) -> UICollectionViewCell? in
            var cell: UICollectionViewCell!
            if indexPath.section == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath)
                if let label = cell.contentView.subviews.first as? UILabel {
                    label.text = (model as? CollectionItem)?.label
                } else {
                    cell.addLabel(with: (model as? CollectionItem)?.label)
                }
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
                if let label = cell.contentView.subviews.first as? UILabel {
                    label.text = (model as? Program)?.name
                } else {
                    cell.addLabel(with: (model as? Program)?.name)
                }
            }
            cell.layer.borderWidth = 1
            return cell
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier, for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }
        return dataSource
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let program = dataSource.itemIdentifier(for: indexPath) as? Program else {
            return
        }
        print("did select program: #\(program.recentAirTime.id) \(program.name) on channel: \(program.recentAirTime.channelID)")
    }
    
    private func applySnapshot(with sections: [CollectionSection], animatingDifferences: Bool = true) {
        var snapshot = AirTimeSnapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            switch section {
            case is ChannelSection:
                snapshot.appendItems((section as! ChannelSection).programs, toSection: section)
            case is TimeLineSection:
                snapshot.appendItems((section as! TimeLineSection).times, toSection: section)
            default: break
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension AirTimeViewController : AirTimeView {
    
    func showAlert(with title: String, _ message: String?) {
        showAlert(with: title, message, actions: [.close])
    }
    
    func showAlert(with title: String, _ message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
}

extension UIAlertAction {
    static let close: UIAlertAction = .init(title: "Close", style: .cancel)
}

extension UICollectionViewCell {
    
    func addLabel(with text: String?) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
}
