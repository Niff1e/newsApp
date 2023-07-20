//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

class NewsTableViewCell: UITableViewCell, NewsListViewCellable {

    static var identifier = "newsTableViewCell"

    var mainView: NewsListMainViewCellable

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.mainView = NewsListMainViewCell()
        super.init(style: .default, reuseIdentifier: NewsTableViewCell.identifier)
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Functions

    private func setupView() {
        self.addSubview(mainView)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // MARK: - Internal Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.clearAllInfo()
    }
}
