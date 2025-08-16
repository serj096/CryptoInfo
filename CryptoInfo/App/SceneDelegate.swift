//
//  SceneDelegate.swift
//  CryptoInfo
//
//  Created by serj on 04.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let _ = (scene as? UIWindowScene) else { return }
           print("👉 scene: willConnectTo")  // <-- добавил вывод
       }

       func sceneDidDisconnect(_ scene: UIScene) {
           print("👉 sceneDidDisconnect")
       }

       func sceneDidBecomeActive(_ scene: UIScene) {
           print("👉 sceneDidBecomeActive")
       }

       func sceneWillResignActive(_ scene: UIScene) {
           print("👉 sceneWillResignActive")
       }

       func sceneWillEnterForeground(_ scene: UIScene) {
           print("👉 sceneWillEnterForeground")
       }

       func sceneDidEnterBackground(_ scene: UIScene) {
           print("👉 sceneDidEnterBackground")
       }
}

