//
//  SceneDelegate.swift
//  newsApp
//
//  Created by Niff1e on 27.02.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabBarVC = UITabBarController()

        let controllers = [createTableVC(), createCollectionVC(), createStackVC()]

        tabBarVC.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }

        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)

        if let tableTabBarItem = tabBarVC.tabBar.items?[0] {
            tableTabBarItem.title = "TableVC"
        }
        if let tableTabBarItem = tabBarVC.tabBar.items?[1] {
            tableTabBarItem.title = "CollectionVC"
        }
        if let tableTabBarItem = tabBarVC.tabBar.items?[2] {
            tableTabBarItem.title = "StackVC"
        }

        window?.windowScene = scene
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }

    // MARK: - Private Functions

    private func createTableVC() -> NewsListViewController {
        let modelForTableVC = NewsListModel()
        let viewForTableVC = NewsListView(view: MainTableView())
        return NewsListViewController(model: modelForTableVC, view: viewForTableVC)
    }

    private func createCollectionVC() -> NewsListViewController {
        let modelForCollectionVC = NewsListModel()
        let viewForCollectionVC = NewsListView(view: MainCollectionView())
        return NewsListViewController(model: modelForCollectionVC, view: viewForCollectionVC)
    }

    private func createStackVC() -> NewsListViewController {
        let modelForStackVC = NewsListModel()
        let viewForStackVC = NewsListView(view: MainScrollView())
        return NewsListViewController(model: modelForStackVC, view: viewForStackVC)
    }
}
