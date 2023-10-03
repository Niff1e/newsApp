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
        let tabBarVC = NewsListTabBarController()

        window?.windowScene = scene
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}
