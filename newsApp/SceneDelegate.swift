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
        let modelForTableVC = NewsListModel()
        let modelForCollectionVC = NewsListModel()
        let firstScreenTableVC = NewsListTableViewController(model: modelForTableVC)
        let firstScreenCollectionVC = NewsListCollectionViewController(model: modelForCollectionVC)
        let controllers = [firstScreenTableVC, firstScreenCollectionVC]
        tabBarVC.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }

        window?.windowScene = scene
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}
