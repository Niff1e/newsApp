//
//  NewsListCollectionView.swift
//  newsApp
//
//  Created by Niff1e on 18.06.23.
//

import Foundation
import UIKit

final class NewsListCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Private Properties

    private var collectionView: UICollectionView = {

        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(NewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        return collectionView
    }()

    private var numberOfItems: Int = 0

    private var noResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("no_results_label", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.isHidden = true
        return label
    }()

    private var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .black
        indicator.style = .large
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()

    // MARK: - Internal Properties

    var getMoreArticles: (() -> Void)?
    var creationOfNewsVC: ((_ number: Int) -> Void)?
    var pictureToCell: ((_ number: Int, _ completion: @escaping (UIImage?) -> Void) -> Void)?
    var textForTitleLabel: ((_ number: Int) -> String?)?
    var textForDescriptionLabel: ((_ number: Int) -> String?)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Colletion View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier,
                                                         for: indexPath) as? NewsCollectionViewCell {
            cell.setDataToCell(titleText: textForTitleLabel?(indexPath.row),
                               descrText: textForDescriptionLabel?(indexPath.row))
            pictureToCell?(indexPath.row) { [weak self] img in
                guard let strongSelf = self else { return }
                let collectionViewCell = strongSelf.collectionView.cellForItem(at: indexPath)
                (collectionViewCell as? NewsCollectionViewCell)?.setImageToCell(image: img)
            }
            return cell
        } else {
            return UICollectionViewListCell()
        }
    }

    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        creationOfNewsVC?(indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == numberOfItems - 1 {
            getMoreArticles?()
        }
    }

    // MARK: - Private Functions

    private func setupCollectionView() {
        self.addSubview(collectionView)
        collectionView.backgroundView = noResultLabel
        self.addSubview(indicator)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            noResultLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            noResultLabel.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
            noResultLabel.heightAnchor.constraint(equalToConstant: 50.0),

            indicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Internal Functions

    func setNumberOfRows(number: Int) {
        self.numberOfItems = number
        collectionView.reloadData()
    }

    func isNoResultLabelVisible(isVisible: Bool) {
        if isVisible {
            noResultLabel.isHidden = false
        } else {
            noResultLabel.isHidden = true
        }
    }

    func isSpinnerAnimated(isAnimated: Bool) {
        if isAnimated {
            self.collectionView.isUserInteractionEnabled = false
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        } else {
            self.collectionView.isUserInteractionEnabled = true
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }

    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else { return }
        let cgRectValue = keyboardFrameSize.cgRectValue
        self.frame.origin.y -= cgRectValue.height
    }

    @objc private func keyboardWillHide() {
        self.frame.origin.y = .zero
    }
}
