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
        newsView.setImage(image: model.picture)
        newsView.setTextToContent(text: model.content)
        newsView.setTextToURLLabel(with: model.pictureURL)
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    override func loadView() {
        view = newsView
    }
}
