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
        setupContainerForImageAndText()
        setupContainerForTitleAndDescr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private let pictureView: UIImageView = {
        let image = UIImageView()

        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        // image.backgroundColor = .blue
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.backgroundColor = .blue
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.backgroundColor = .blue
        return label
    }()

    private let containerForTitleAndDescr: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false
        // container.backgroundColor = .red
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
            titleLabel.topAnchor.constraint(equalTo: containerForTitleAndDescr.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: containerForTitleAndDescr.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22.0),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerForTitleAndDescr.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22.0),
            descriptionLabel.widthAnchor.constraint(equalTo: containerForTitleAndDescr.widthAnchor)
        ])
    }

    private func setupContainerForImageAndText() {
        self.addSubview(containerForImageAndText)
        containerForImageAndText.addSubview(pictureView)
        containerForImageAndText.addSubview(containerForTitleAndDescr)

        NSLayoutConstraint.activate([
            containerForImageAndText.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            containerForImageAndText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            containerForImageAndText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            containerForImageAndText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            pictureView.heightAnchor.constraint(equalToConstant: 50.0),
            pictureView.widthAnchor.constraint(equalToConstant: 50.0),
            pictureView.leadingAnchor.constraint(equalTo: containerForImageAndText.leadingAnchor),
            containerForTitleAndDescr.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 20.0),
            containerForTitleAndDescr.trailingAnchor.constraint(equalTo: containerForImageAndText.trailingAnchor, constant: -40.0)
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
