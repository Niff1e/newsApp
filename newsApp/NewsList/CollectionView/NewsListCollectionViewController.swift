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

    // MARK: -

    private func setupNavigation() {
        navigationItem.title = .navigationBarName
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    override func loadView() {
        self.view = newsListCollectionView
    }
}

extension NewsListCollectionViewController: UISearchBarDelegate {}
