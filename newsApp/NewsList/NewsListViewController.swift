//
//  ViewController.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import Foundation
import UIKit

final class NewsListViewController: UITableViewController {

    private let model: NewsListModel
    private let newsListView = NewsListView()

    init(model: NewsListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupNavigation() {
        navigationItem.title = "NEWS"
        guard let nav = navigationController?.navigationBar else { return }
        nav.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
    }

    override func loadView() {
        view = newsListView
    }
}

