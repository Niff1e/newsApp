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

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        return stackView
    }()

    private var pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.contentMode = .scaleAspectFit
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        pictureView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return pictureView
    }()

    private var pictureHeightConstraintConstant = CGFloat()

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
        return label
    }()

    private var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private var publishDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Private Funtions

    private func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setupStackView() {
        stackView.addArrangedSubview(pictureView)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(urlView)

        pictureView.addSubview(titleLabel)
        pictureView.addSubview(authorLabel)
        pictureView.addSubview(publishDateLabel)

        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor, constant: 16.0),
            authorLabel.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: -8.0),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: publishDateLabel.leadingAnchor, constant: -8.0),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),

            publishDateLabel.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: -8.0),
            publishDateLabel.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -16.0),
            publishDateLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -16.0)
        ])
    }

    // MARK: - Internal Functions

    func setImage(image: UIImage?) {
        guard let pic = image else {
            self.pictureView.image = nil
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

    func setInfoTo(title: String?, publishDate: String?, author: String?) {
        self.titleLabel.text = title
        self.publishDateLabel.text = publishDate
        self.authorLabel.text = author
    }
}
