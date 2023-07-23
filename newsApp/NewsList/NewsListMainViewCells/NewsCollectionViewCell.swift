//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

class NewsCollectionViewCell: UICollectionViewListCell, NewsListViewCellable {

    static let identifier = "newsCollectionViewCell"

    private(set) var mainView: NewsListMainViewCellable

    override init(frame: CGRect) {
        self.mainView = NewsViewForCell()
        super.init(frame: .zero)
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Functions

    private func setupView() {
        self.contentView.addSubview(mainView)

        let bottomConstraint = mainView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        bottomConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bottomConstraint,
            mainView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }

    // MARK: - Internal Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.clearAllInfo()
    }
}
