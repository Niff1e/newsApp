//
//  NewsListMainView.swift
//  newsApp
//
//  Created by Niff1e on 16.07.23.
//

import Foundation
import UIKit

final class MainScrollView: UIScrollView, UIScrollViewDelegate, NewsListMainViewable {

    // MARK: Private Properties

    private var numberOfRows: Int = 0
    private var numberOfTappingCell: Int = 0

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Properties

    var getMoreArticles: (() -> Void)?
    var creationOfNewsVC: ((Int) -> Void)?
    var pictureToCell: ((Int, @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((Int) -> String?)?
    var textForDescriptionLabel: ((Int) -> String?)?

    // MARK: - Private Functions

    private func setupView() {
        self.addSubview(stackView)

        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            bottomAnchor,
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func addMultipleViews(quantity: Int) {
        for count in self.numberOfRows...(quantity - 1) {
            let cell = NewsListMainViewCell(count: count)
            print(count)
            pictureToCell?(count) { [weak self] img in
                cell.setImageToCell(image: img)
                cell.setDataToCell(titleText: self?.textForTitleLabel?(count),
                                   descrText: self?.textForDescriptionLabel?(count))
                self?.setupCellGesture(cell: cell)
                self?.stackView.addArrangedSubview(cell)
            }
        }
    }

    @objc private func cellTapAction(cell: NewsListMainViewCell) {
        creationOfNewsVC?(cell.countInStack)
    }

    private func setupCellGesture(cell: NewsListMainViewCell) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapAction(cell:)))
        self.addGestureRecognizer(tap)
    }

    // MARK: - Scroll View Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y

        if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
            getMoreArticles?()
        }
    }

    // MARK: - Internal Functions

    func setNumberOfRows(number: Int) {
        if number > self.numberOfRows {
            addMultipleViews(quantity: number)
            self.numberOfRows = number
        }
    }
}
