//
//  NewsViewForCell.swift
//  newsApp
//
//  Created by Niff1e on 22.07.23.
//

import Foundation
import UIKit

final class NewsViewForCell: UIView, NewsListMainViewCellable {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        container.alignment = .center
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

    private let accessoryView: UIImageView = {
        let imageView = UIImageView()
        let chevron = UIImage(systemName: "chevron.right")
        imageView.image = chevron
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Private Functions

    private func setupContainerForTitleAndDescr() {
        containerForTitleAndDescr.addSubview(titleLabel)
        containerForTitleAndDescr.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerForTitleAndDescr.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: containerForTitleAndDescr.widthAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerForTitleAndDescr.bottomAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: containerForTitleAndDescr.widthAnchor)
        ])
    }

    private func setupContainerForImageAndText() {
        self.addSubview(containerForImageAndText)
        self.addSubview(accessoryView)
        containerForImageAndText.addSubview(pictureView)
        containerForImageAndText.addSubview(containerForTitleAndDescr)

        NSLayoutConstraint.activate([
            accessoryView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            accessoryView.leadingAnchor.constraint(equalTo: containerForImageAndText.trailingAnchor),
            accessoryView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            accessoryView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25.0),

            containerForImageAndText.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            containerForImageAndText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            containerForImageAndText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),

            pictureView.topAnchor.constraint(equalTo: containerForImageAndText.topAnchor, constant: 16.0),
            pictureView.heightAnchor.constraint(equalToConstant: 50.0),
            pictureView.widthAnchor.constraint(equalToConstant: 50.0),
            pictureView.leadingAnchor.constraint(equalTo: containerForImageAndText.leadingAnchor, constant: 16.0),
            pictureView.bottomAnchor.constraint(lessThanOrEqualTo: containerForImageAndText.bottomAnchor,
                                                constant: -16.0),

            containerForTitleAndDescr.topAnchor.constraint(equalTo: containerForImageAndText.topAnchor, constant: 16.0),
            containerForTitleAndDescr.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 20.0),
            containerForTitleAndDescr.bottomAnchor.constraint(equalTo: containerForImageAndText.bottomAnchor,
                                                              constant: -16.0),
            // swiftlint:disable:next line_length
            containerForTitleAndDescr.trailingAnchor.constraint(lessThanOrEqualTo: containerForImageAndText.trailingAnchor,
                                                                constant: -40.0)
        ])
    }

    // MARK: - Internal Functions

    func setDataToCell(titleText: String?, descriptionText descrText: String?) {
        titleLabel.text = titleText
        descriptionLabel.text = descrText
    }

    func setImageToCell(image: UIImage?) {
        pictureView.image = image
    }

    func clearAllInfo() {
        pictureView.image = nil
        descriptionLabel.text = nil
        titleLabel.text = nil
    }
}
