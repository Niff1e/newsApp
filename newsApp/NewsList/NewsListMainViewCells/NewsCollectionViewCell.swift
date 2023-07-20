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

    var mainView: NewsListMainViewCellable

    override init(frame: CGRect) {
        self.mainView = NewsListMainViewCell()
        super.init(frame: .zero)
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private let customAccessory: UICellAccessory.CustomViewConfiguration = {
        let image = UIImage(systemName: "chevron.right")
        let customAccessory = UICellAccessory.CustomViewConfiguration(customView: UIImageView(image: image),
                                                                      placement: .trailing(displayed: .always))
        return customAccessory
    }()

    // MARK: - Private Functions

    private func setupView() {
        self.addSubview(mainView)
        self.accessories = [.customView(configuration: customAccessory)]

        let bottomConstraint = mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomConstraint,
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // MARK: - Internal Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.clearAllInfo()
    }
}
