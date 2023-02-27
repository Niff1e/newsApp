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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let navigationVC = UINavigationController()
        let model = NewsListModel()
        let firstScreenVC = NewsListViewController(model: model)
        window?.backgroundColor = .white
    
        window?.windowScene = windowScene
        window?.rootViewController = navigationVC
        navigationVC.pushViewController(firstScreenVC, animated: false)
        window?.makeKeyAndVisible()
    }
}
