//
//  NewsView.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsView: UIView {

    // MARK: - INIT

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupScrollView()
        setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Properties

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()

    private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    private var authorAndPublishDateView: UIView = {
        let authorAndPublishDateView = UIView()
        authorAndPublishDateView.translatesAutoresizingMaskIntoConstraints = false
        return authorAndPublishDateView
    }()

    private var pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.contentMode = .scaleAspectFit
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        return pictureView
    }()

    private var pictureHeightConstraintConstant = CGFloat()
    private var pictureWidthConstraintConstant = CGFloat()

    private var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var urlView: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 16.0)
        field.isScrollEnabled = false
        return field
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.layer.shadowColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = .zero
        return label
    }()

    private var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textColor = .black
        label.layer.shadowColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = .zero
        return label
    }()

    private var publishDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .black
        label.layer.shadowColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = .zero
        return label
    }()

    // MARK: - Private Funtions

    private func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setupStackView() {
        mainStackView.addArrangedSubview(pictureView)
        mainStackView.addArrangedSubview(contentLabel)
        mainStackView.addArrangedSubview(urlView)

        pictureView.addSubview(titleStackView)

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(authorAndPublishDateView)

        authorAndPublishDateView.addSubview(authorLabel)
        authorAndPublishDateView.addSubview(publishDateLabel)

        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor, constant: 8.0),
            titleStackView.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -8.0),
            titleStackView.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: -8.0),
            titleStackView.topAnchor.constraint(greaterThanOrEqualTo: pictureView.topAnchor),

            publishDateLabel.bottomAnchor.constraint(equalTo: authorAndPublishDateView.bottomAnchor),
            publishDateLabel.trailingAnchor.constraint(equalTo: authorAndPublishDateView.trailingAnchor),
            publishDateLabel.topAnchor.constraint(equalTo: authorAndPublishDateView.topAnchor),

            authorLabel.leadingAnchor.constraint(equalTo: authorAndPublishDateView.leadingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: authorAndPublishDateView.bottomAnchor),
            authorLabel.topAnchor.constraint(equalTo: authorAndPublishDateView.topAnchor)
        ])

        let constraint = publishDateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: authorLabel.trailingAnchor,
                                                                   constant: 8.0)
        constraint.priority = .required
        constraint.isActive = true
    }

    // MARK: - Internal Functions

    func setImage(image: UIImage?) {
        guard let pic = image else {
            self.pictureView.image = nil
            pictureHeightConstraintConstant = titleStackView.frame.size.height
            pictureWidthConstraintConstant = self.frame.size.width
            return
        }
        if self.safeAreaLayoutGuide.layoutFrame.size.width < pic.size.width {
            pictureHeightConstraintConstant = (self.frame.size.width * pic.size.height) / pic.size.width
            NSLayoutConstraint.activate([
                pictureView.heightAnchor.constraint(equalToConstant: pictureHeightConstraintConstant)
            ])
        }
        self.pictureView.image = image
    }

    func setTextToContent(text: String?) {
        self.contentLabel.text = text
    }

    func setTextToURLView(with url: URL?) {
        guard let url = url else {
            self.urlView.text = ""
            self.urlView.isUserInteractionEnabled = false
            return
        }
        self.urlView.text = url.absoluteString
        self.urlView.isEditable = false
        self.urlView.dataDetectorTypes = .link
    }

    func setInfoTo(title: String?, author: String?) {
        self.titleLabel.text = title
        self.authorLabel.text = author
    }

    func setDateToDateLabel(publishDate: String) {
        self.publishDateLabel.text = publishDate
    }
}
