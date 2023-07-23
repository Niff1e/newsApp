//
//  NewsListMainViewCell.swift
//  newsApp
//
//  Created by Niff1e on 12.07.23.
//

import Foundation
import UIKit

class NewsScrollViewCell: UIView, NewsListViewCellable {

    // MARK: - Internal Properties

    private(set) var mainView: NewsListMainViewCellable

    var numberOfCell: ((Int) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        self.mainView = NewsViewForCell()
        super.init(frame: .zero)
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupTapGesture()
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

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapping))
        self.addGestureRecognizer(tap)
    }

    @objc private func tapping() {
        numberOfCell?(tag)
    }
}
