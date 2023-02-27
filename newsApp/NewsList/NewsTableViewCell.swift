//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

class NewsTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerForTitleAndDescr: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        container.alignment = .fill
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private let containerForImageAndText: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 20
        container.alignment = .fill
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private func setupContainer() {
        containerForTitleAndDescr.addSubview(titleLabel)
        containerForTitleAndDescr.addSubview(descriptionLabel)
    }

    private func setupFullView() {
        self.addSubview(containerForImageAndText)
        containerForImageAndText.addSubview(image)
        containerForImageAndText.addSubview(containerForTitleAndDescr)

        NSLayoutConstraint.activate([
            containerForImageAndText.topAnchor.constraint(equalTo: self.topAnchor),
            containerForImageAndText.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerForImageAndText.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerForImageAndText.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
