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
    private var int = 0

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
        guard let nav = navigationController?.navigationBar else { return }
        nav.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
        view.backgroundColor = .white
        setupNavigation()

        model.showAlert = { [weak self] (code, message) -> Void in
            self?.showAlert(with: code, and: message)
        }

        model.getData(from: model.stringURL) { [weak self] articles in
            self?.newsListView.setNumberOfRows(number: articles.count)

            self?.newsListView.creationOfNewsVC = { [weak self] (number) -> Void in
                guard let strongSelf = self else { return }
                let articleForNumber = articles[number]
                strongSelf.model.downloadImage(with: articleForNumber.urlToImage) { img in
                        let model = NewsModel(image: img, content: articleForNumber.content, pictureURL: articleForNumber.urlToImage)
                        let newsVC = NewsViewController(model: model)
                        strongSelf.navigationController?.pushViewController(newsVC, animated: true)
                }
            }

            self?.newsListView.pictureToCell = { [weak self] (number, completion) in
                guard let strongSelf = self else { return }
                let articleForNumber = articles[number]
                guard let urlPicture = articleForNumber.urlToImage else { return }
                strongSelf.model.downloadImage(with: urlPicture) { img in
                    completion(img)
                }
            }

            self?.newsListView.textForTitleLabel = { (number) -> String? in
                let articleForNumber = articles[number]
                return articleForNumber.title
            }

            self?.newsListView.textForDescriptionLabel = { (number) -> String? in
                let articleForNumber = articles[number]
                return articleForNumber.description
            }
        }
    }

    override func loadView() {
        view = newsListView
    }
}

