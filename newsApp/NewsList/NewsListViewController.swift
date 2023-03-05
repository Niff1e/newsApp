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

        newsListView.creationOfNewVC = {[weak self] in
            guard let strongSelf = self else { return }
            let newsVC = NewsViewController()
            strongSelf.navigationController?.pushViewController(newsVC, animated: true)
        }
    }

    override func loadView() {
        view = newsListView
    }
}

