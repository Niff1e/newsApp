//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

class NewsCollectionViewCell: UICollectionViewListCell {

    static let identifier = "newsCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue
        setupContainerForImageAndText()
        setupContainerForTitleAndDescr()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private let pictureView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .green
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        return label
    }()

    private let containerForTitleAndDescr: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .center
        container.alignment = .fill
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private let containerForImageAndText: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .fill
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    // MARK: - Private Functions

    private func setupContainerForTitleAndDescr() {
        containerForTitleAndDescr.addSubview(titleLabel)
        containerForTitleAndDescr.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: containerForTitleAndDescr.topAnchor),
//            titleLabel.widthAnchor.constraint(equalTo: containerForTitleAndDescr.widthAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
//            descriptionLabel.bottomAnchor.constraint(equalTo: containerForTitleAndDescr.bottomAnchor),
//            descriptionLabel.widthAnchor.constraint(equalTo: containerForTitleAndDescr.widthAnchor)
        ])
    }

    private func setupContainerForImageAndText() {
        self.contentView.addSubview(containerForImageAndText)
        containerForImageAndText.addSubview(pictureView)
        containerForImageAndText.addSubview(containerForTitleAndDescr)

        NSLayoutConstraint.activate([
//            containerForImageAndText.topAnchor.constraint(equalTo: self.topAnchor, constant: 26.0),
//            containerForImageAndText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26.0),
//            containerForImageAndText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26.0),
//            containerForImageAndText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26.0),

//            pictureView.topAnchor.constraint(equalTo: containerForImageAndText.topAnchor),
//            pictureView.heightAnchor.constraint(equalToConstant: 50.0),
//            pictureView.widthAnchor.constraint(equalToConstant: 50.0),
//            pictureView.leadingAnchor.constraint(equalTo: containerForImageAndText.leadingAnchor),
//            // swiftlint:disable:next line_length
//            pictureView.bottomAnchor.constraint(lessThanOrEqualTo: containerForImageAndText.bottomAnchor),

//            containerForTitleAndDescr.topAnchor.constraint(equalTo: containerForImageAndText.topAnchor, constant: 16.0),
            containerForTitleAndDescr.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 20.0),
//            // swiftlint:disable:next line_length
//            containerForTitleAndDescr.bottomAnchor.constraint(equalTo: containerForImageAndText.bottomAnchor, constant: -16.0),
//            // swiftlint:disable:next line_length
//            containerForTitleAndDescr.trailingAnchor.constraint(lessThanOrEqualTo: containerForImageAndText.trailingAnchor, constant: -40.0)
        ])
    }

    // MARK: - Internal Functions

    func setDataToCell(titleText: String?, descrText: String?) {
        titleLabel.text = titleText
        descriptionLabel.text = descrText
    }

    func setImageToCell(image: UIImage?) {
        pictureView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.image = nil
        descriptionLabel.text = nil
        titleLabel.text = nil
    }
}
