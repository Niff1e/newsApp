//
//  ViewController.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsListViewController: UITableViewController {

    // MARK: - Private Properties

    private let model: NewsListModel
    private let newsListView = NewsListView()
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
        navigationItem.title = NSLocalizedString("navigation_bar_name", comment: "")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func showAlert(with code: String, and message: String) {
        let alert = UIAlertController(title: code, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("alert_button", comment: ""), style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()

        model.getArticles(about: nil) { [weak self] articles in
            self?.newsListView.setNumberOfRows(number: articles.count)
        }
    }

    override func loadView() {
        view = newsListView

        model.showAlert = { [weak self] (code, message) -> Void in
            self?.showAlert(with: code, and: message)
        }

        model.showNoResult = { [weak self] in
            self?.newsListView.makeLabelVisible()
        }

        model.hideNoResult = { [weak self] in
            self?.newsListView.makeLabelInvisible()
        }

        model.whenStartDownload = { [weak self] in
            self?.newsListView.startAnimatingIndicator()
        }

        model.whenFinishDownload = { [weak self] in
            self?.newsListView.stopAnimatingIndicator()
        }

        newsListView.creationOfNewsVC = { [weak self] (number) -> Void in
            guard let strongSelf = self else { return }
            let articleForNumber = strongSelf.model.articles[number]
            let model = NewsModel(article: articleForNumber)
            let newsVC = NewsViewController(model: model)
            strongSelf.navigationController?.pushViewController(newsVC, animated: true)
        }

        newsListView.pictureToCell = { [weak self] (number, completion) in
            guard let strongSelf = self else { return }
            let articleForNumber = strongSelf.model.articles[number]
            guard let urlPicture = articleForNumber.urlToImage else {
                completion(nil)
                return
            }
            strongSelf.model.dowloadImage(urlPicture, { img in
                completion(img)
            })
        }

        newsListView.textForTitleLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            let articleForNumber = strongSelf.model.articles[number]
            return articleForNumber.title
        }

        newsListView.textForDescriptionLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            let articleForNumber = strongSelf.model.articles[number]
            return articleForNumber.description
        }

        newsListView.getMoreArticles = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.model.getArticles(about: nil) { [weak self] article in
                self?.newsListView.setNumberOfRows(number: article.count)
            }
        }
    }
}

extension NewsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        model.getArticles(about: searchBar.text) { [weak self] articles in
            self?.newsListView.setNumberOfRows(number: articles.count)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.getArticles(about: "") { [weak self] articles in
            self?.newsListView.setNumberOfRows(number: articles.count)
        }
    }
}
