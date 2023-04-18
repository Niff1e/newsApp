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

    private var labelContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var labelURL: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.0)
        label.isScrollEnabled = false
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
        stackView.addArrangedSubview(labelContent)
        stackView.addArrangedSubview(labelURL)
    }

    // MARK: - Internal Functions

    func setImage(image: UIImage?) {
//        guard let pic = image else {
//            self.pictureView.image = nil
//            return
//        }
//        if self.safeAreaLayoutGuide.layoutFrame.size.width < pic.size.width {
//            print(self.safeAreaLayoutGuide.layoutFrame.size.width)
//            let height = (self.frame.size.width * pic.size.height) / pic.size.width
//            print(height)
//            NSLayoutConstraint.activate([
//                pictureView.heightAnchor.constraint(equalToConstant: height)
//            ])
//        }
        self.pictureView.image = image
    }

    func setTextToContent(text: String?) {
        self.labelContent.text = text
    }

    func setTextToURLLabel(with url: URL?) {
        guard let url = url else {
            self.labelURL.text = ""
            return
        }
        self.labelURL.text = url.absoluteString
        self.labelURL.isEditable = false
        self.labelURL.dataDetectorTypes = .link
    }
}
