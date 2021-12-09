//
//  SceneDelegate.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = SearchViewController(with: SearchViewModel())
        self.window?.makeKeyAndVisible()
    }
}



