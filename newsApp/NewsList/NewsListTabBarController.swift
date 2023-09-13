//
//  NewsListTabBarController.swift
//  newsApp
//
//  Created by Niff1e on 12.08.23.
//

import Foundation
import UIKit

final class NewsListTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let controllers = [createTableVC(), createCollectionVC(), createStackVC()]
        let navigationVCs = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        self.setViewControllers(navigationVCs, animated: false)

        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }

    // MARK: - Private Functions

    private func createTableVC() -> NewsListViewController {
        let modelForTableVC = NewsListModel()
        let viewForTableVC = NewsListView(view: MainTableView())
        let controller = NewsListViewController(model: modelForTableVC, view: viewForTableVC)
        controller.title = .tableController
        return controller
    }

    private func createCollectionVC() -> NewsListViewController {
        let modelForCollectionVC = NewsListModel()
        let viewForCollectionVC = NewsListView(view: MainCollectionView())
        let controller = NewsListViewController(model: modelForCollectionVC, view: viewForCollectionVC)
        controller.title = .collectionController
        return controller
    }

    private func createStackVC() -> NewsListViewController {
        let modelForStackVC = NewsListModel()
        let viewForStackVC = NewsListView(view: MainScrollView())
        let controller = NewsListViewController(model: modelForStackVC, view: viewForStackVC)
        controller.title = .stackController
        return controller
    }
}
