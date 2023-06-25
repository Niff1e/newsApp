//
//  SecondNewsListViewController.swift
//  newsApp
//
//  Created by Niff1e on 18.06.23.
//

import Foundation
import UIKit

final class NewsListCollectionViewController: UICollectionViewController {

    // MARK: - Private Properties

    private let model: NewsListModel
    private let newsListCollectionView = NewsListCollectionView()

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Init

    init(model: NewsListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Functions

    private func setupNavigation() {
        navigationItem.title = .navigationBarName
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func showAlert(with code: String, and message: String) {
        let alert = UIAlertController(title: code, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: .alertButton, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        model.getArticles(about: nil) { [weak self] articles in
            self?.newsListCollectionView.setNumberOfRows(number: articles.count)
        }
    }

    override func loadView() {
        self.view = newsListCollectionView
        model.showAlert = { [weak self] (code, message) -> Void in
            self?.showAlert(with: code, and: message)
        }

        model.isNoResultLabelVisible = { [weak self] (isVisible) -> Void in
            self?.newsListCollectionView.isNoResultLabelVisible(isVisible: isVisible)
        }

        model.isSpinnerAnimated = { [weak self] (isAnimated) -> Void in
            self?.newsListCollectionView.isSpinnerAnimated(isAnimated: isAnimated)
        }

        newsListCollectionView.creationOfNewsVC = { [weak self] (number) -> Void in
            guard let strongSelf = self else { return }
            let articleForNumber = strongSelf.model.articles[number]
            let model = NewsModel(article: articleForNumber)
            let newsVC = NewsViewController(model: model)
            strongSelf.navigationController?.pushViewController(newsVC, animated: true)
        }

        newsListCollectionView.pictureToCell = { [weak self] (number, completion) in
            guard let strongSelf = self else { return }
            let articleForNumber = strongSelf.model.articles[number]
            guard let urlPicture = articleForNumber.urlToImage else {
                completion(nil)
                return
            }
            strongSelf.model.dowloadImage(url: urlPicture, completion: { img in
                completion(img)
            })
        }

        newsListCollectionView.textForTitleLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            let articleForNumber = strongSelf.model.articles[number]
            return articleForNumber.title
        }

        newsListCollectionView.textForDescriptionLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            let articleForNumber = strongSelf.model.articles[number]
            return articleForNumber.description
        }

        newsListCollectionView.getMoreArticles = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.model.getArticles(about: nil) { [weak self] article in
                self?.newsListCollectionView.setNumberOfRows(number: article.count)
            }
        }
    }
}

extension NewsListCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.model.setIsFirstScreen(to: false)
        model.getArticles(about: searchBar.text) { [weak self] articles in
            self?.newsListCollectionView.setNumberOfRows(number: articles.count)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.model.setIsFirstScreen(to: true)
        self.model.setFirstPartOfArticles()
        model.getArticles(about: "") { [weak self] articles in
            self?.newsListCollectionView.setNumberOfRows(number: articles.count)
        }
    }
}
