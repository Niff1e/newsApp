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

        guard let articles = model.getData(from: model.stringURL) else { return }
        newsListView.setNumberOfRows(number: articles.count)

        newsListView.creationOfNewsVC = {[weak self] (number) -> Void in
            guard let strongSelf = self else { return }
            guard let content = articles[number].content else { return }
            guard let pictureURL = articles[number].urlToImage else { return }
            strongSelf.model.downloadImage(with: pictureURL)
            guard let image = strongSelf.model.picture else { return }
            let model = NewsModel(image: image, content: content, pictureURL: pictureURL)
            let newsVC = NewsViewController(model: model)
            strongSelf.navigationController?.pushViewController(newsVC, animated: true)
        }

        newsListView.pictureToCell = {[weak self] (number) -> UIImage? in
            guard let urlPicture = articles[number].urlToImage else { return nil}
            self?.model.downloadImage(with: urlPicture)
            guard let image = self?.model.picture else { return nil }
            return image
        }

        newsListView.textForTitleLabel = { (number) -> String in
            return articles[number].title
        }

        newsListView.textForDescriptionLabel = { (number) -> String? in
            guard let descr = articles[number].description else { return nil }
            return descr
        }
    }

    override func loadView() {
        view = newsListView
    }
}

