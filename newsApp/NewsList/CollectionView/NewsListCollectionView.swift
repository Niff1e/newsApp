//
//  NewsListCollectionView.swift
//  newsApp
//
//  Created by Niff1e on 18.06.23.
//

import Foundation
import UIKit

final class NewsListCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Private Properties

    private var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        return collectionView
    }()

    private var numberOfRows: Int = 10

    // MARK: - Internal Properties

    var getMoreArticles: (() -> Void)?
    var creationOfNewsVC: ((_ number: Int) -> Void)?
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((_ number: Int) -> String?)?
    var textForDescriptionLabel: ((_ number: Int) -> String?)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Colletion View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath)
            // cell.contentView.backgroundColor = .red
            //            cell.setDataToCell(titleText: textForTitleLabel?(indexPath.row),
            //                               descrText: textForDescriptionLabel?(indexPath.row))
            //            pictureToCell?(indexPath.row) { [weak self] img in
            //                guard let strongSelf = self else { return }
            //                let collectionViewCell = strongSelf.collectionView.cellForItem(at: indexPath)
            //                (collectionViewCell as? NewsCollectionViewCell)?.setImageToCell(image: img)
            //            }
            //            return cell
            //        } else {
            //            return UICollectionViewListCell()
            //        }
        return cell
    }

    // MARK: - Private Functions

    private func setupCollectionView() {
        self.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: collectionView.frame.size.width-2, height: 100)
        collectionView.collectionViewLayout = layout
    }
}
