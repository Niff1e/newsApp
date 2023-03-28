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
        // stackView.backgroundColor = .blue
        return stackView
    }()

    private var pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.contentMode = .scaleAspectFit
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.backgroundColor = .blue
        return pictureView
    }()

    private var labelContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.font = UIFont.systemFont(ofSize: 75.0)
        label.backgroundColor = .red
        label.numberOfLines = 0
        return label
    }()

    private var labelURL: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.font = UIFont.systemFont(ofSize: 75.0)
        label.backgroundColor = .green
        label.numberOfLines = 0
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
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setupStackView() {
        stackView.addArrangedSubview(pictureView)
        stackView.addArrangedSubview(labelContent)
        stackView.addArrangedSubview(labelURL)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            pictureView.heightAnchor.constraint(equalToConstant: 400.0),
//            labelContent.heightAnchor.constraint(equalToConstant: 400.0),
//            labelURL.heightAnchor.constraint(equalToConstant: 400.0)
        ])
    }

    // MARK: - Internal Functions

    func setImage(image: UIImage?) {
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
        do {
            let text = try String(contentsOf: url)
            self.labelURL.text = text
        } catch {
            print(error)
        }
    }
}
