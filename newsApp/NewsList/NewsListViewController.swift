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
        navigationItem.title = "NEWS"
    }

    private func showAlert(with code: String, and message: String) {
        let alert = UIAlertController(title: code, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()

        model.getData { [weak self] articles in
            self?.newsListView.setNumberOfRows(number: articles.count)
        }
    }

    override func loadView() {
        view = newsListView

        model.showAlert = { [weak self] (code, message) -> Void in
            self?.showAlert(with: code, and: message)
        }

        newsListView.creationOfNewsVC = { [weak self] (number) -> Void in
            guard let strongSelf = self else { return }
            let articleForNumber = strongSelf.model.articles?[number]
            strongSelf.model.dowloadImage(articleForNumber?.urlToImage, {img in
                let model = NewsModel(image: img, article: articleForNumber)
                let newsVC = NewsViewController(model: model)
                        strongSelf.navigationController?.pushViewController(newsVC, animated: true)
            })
        }

        newsListView.pictureToCell = { [weak self] (number, completion) in
            guard let strongSelf = self else { return }
            let articleForNumber = strongSelf.model.articles?[number]
            guard let urlPicture = articleForNumber?.urlToImage else {
                completion(nil)
                return
            }
            strongSelf.model.dowloadImage(urlPicture, { img in
                completion(img)
            })
        }

        newsListView.textForTitleLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            let articleForNumber = strongSelf.model.articles?[number]
            return articleForNumber?.title
        }

        newsListView.textForDescriptionLabel = { [weak self] (number) -> String? in
            guard let strongSelf = self else { return nil }
            let articleForNumber = strongSelf.model.articles?[number]
            return articleForNumber?.description
        }
    }
}
