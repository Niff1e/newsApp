//
//  NewsListCollectionView.swift
//  newsApp
//
//  Created by Niff1e on 18.06.23.
//

import Foundation
import UIKit

final class MainCollectionView: UICollectionView,
                                    UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    NewsListMainViewable {

    // MARK: Private Properties

    private var numberOfItems: Int = 0

    // MARK: - Internal Properties

    var getMoreArticles: (() -> Void)?
    var creationOfNewsVC: ((_ number: Int) -> Void)?
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((_ number: Int) -> String?)?
    var textForDescriptionLabel: ((_ number: Int) -> String?)?

    // MARK: - Init

    init() {
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .white
        self.register(NewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        self.dataSource = self
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Colletion View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier,
                                                         for: indexPath) as? NewsCollectionViewCell {
            cell.mainView.setDataToCell(titleText: textForTitleLabel?(indexPath.row),
                                        descriptionText: textForDescriptionLabel?(indexPath.row))
            pictureToCell?(indexPath.row) { [weak self] img in
                guard let strongSelf = self else { return }
                let collectionViewCell = strongSelf.cellForItem(at: indexPath)
                (collectionViewCell as? NewsCollectionViewCell)?.mainView.setImageToCell(image: img)
            }
            return cell
        } else {
            return UICollectionViewListCell()
        }
    }

    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        creationOfNewsVC?(indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == numberOfItems - 1 {
            getMoreArticles?()
        }
    }

    // MARK: - Internal Functions

    func setNumberOfRows(number: Int) {
        self.numberOfItems = number
        self.reloadData()
    }
}
