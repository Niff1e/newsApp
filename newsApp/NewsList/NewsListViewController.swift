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

    func setupNavigation() {
        navigationItem.title = "NEWS"
        guard let nav = navigationController?.navigationBar else { return }
        nav.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()

        guard let info = model.getData() else { return }
        newsListView.setNumberOfRows(number: info.articles.count)

        newsListView.creationOfNewVC = {[weak self] (number) -> () in
            guard let strongSelf = self else { return }
            guard let content = info.articles[number].content else { return }
            guard let pictureURL = info.articles[number].urlToImage else { return }
            let image = strongSelf.model.downloadImage(with: pictureURL)
            let model = NewsModel(image: image, content: content, pictureURL: pictureURL)
            let newsVC = NewsViewController(model: model)
            strongSelf.navigationController?.pushViewController(newsVC, animated: true)
        }

        newsListView.pictureToCell = {[weak self] (number) -> UIImage? in
            guard let urlPicture = info.articles[number].urlToImage else { return nil }
            let image = self?.model.downloadImage(with: urlPicture)
            return image
        }

        newsListView.textForTitleLabel = {[weak self] (number) -> String in
            return info.articles[number].title
        }

        newsListView.textForDescriptionLabel = {[weak self] (number) -> String in
            return info.articles[number].description
        }

    }

    override func loadView() {
        view = newsListView
    }
}

