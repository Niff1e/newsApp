//
//  NewsViewController.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsViewController: UIViewController {

    init(model: NewsModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let model: NewsModel
    private let newsView = NewsView()

    // MARK: - Private methods

    private func updateView() {
        newsView.setTextToContent(text: model.article?.content)
        newsView.setTextToURLView(with: model.article?.url)
        newsView.setInfoTo(title: model.article?.title,
                           publishDate: model.article?.publishedAt,
                           author: model.article?.author)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = model.article?.title

        model.updatePicture = { [weak self] img in
            self?.newsView.setImage(image: img)
        }

        model.dowloadImage()
        updateView()
    }

    override func loadView() {
        view = newsView
    }
}
