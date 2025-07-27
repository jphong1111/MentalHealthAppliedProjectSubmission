//
//  SceneDelegate.swift
//  MentalHealth
//
//

import UIKit
import SwiftEntryKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var sessionStartTime: Date?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        let isAutoSignInEnabled = UserDefaults.standard.bool(forKey: "autoSignInEnabled")
//
//        if isAutoSignInEnabled,
//           let savedEmail = UserDefaults.standard.string(forKey: "savedEmail"),
//           let savedPassword = KeychainHelper.shared.getPassword(for: savedEmail) {
//
//            // Perform sign-in using async/await
//            Task {
//                let result = await FBNetworkLayer.shared.logIn(email: savedEmail, password: savedPassword)
//
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success:
//                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
//                        self.showAlert(title: .localized(.success), description: "Auto sign-in success")
//
//                        let homeVC = storyboard.instantiateViewController(identifier: "HomeTabBarController")
//                        window.rootViewController = UINavigationController(rootViewController: homeVC)
//
//                    case .failure(let error):
//                        print("Auto sign-in failed:", error.localizedDescription)
//
//                        let loginVC = storyboard.instantiateViewController(identifier: "LogInViewController")
//                        window.rootViewController = UINavigationController(rootViewController: loginVC)
//                    }
//
//                    self.window = window
//                    window.makeKeyAndVisible()
//                }
//            }
//        } else {
//            let loginVC = storyboard.instantiateViewController(identifier: "LogInViewController")
//            window.rootViewController = UINavigationController(rootViewController: loginVC)
//            self.window = window
//            window.makeKeyAndVisible()
//        }
    }
    
    private func showAlert(title: String, description: String) {
        var attributes = EKAttributes.topFloat
        attributes.entryBackground = .color(color: .white)
        attributes.displayDuration = 3
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: SoliUFont.bold14, color: .black))
        let description = EKProperty.LabelContent(text: description, style: .init(font: SoliUFont.regular14, color: .black))
        let image = EKProperty.ImageContent(image: ImageAsset.soliuLogoOnly.image, size: CGSize(width: 40, height: 40))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
        
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        sessionStartTime = Date()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        guard let start = sessionStartTime else { return }
            let sessionDuration = Date().timeIntervalSince(start) / 60
            let previousTotal = UserDefaults.standard.double(forKey: "totalAppUsageMinutes")
            UserDefaults.standard.set(previousTotal + sessionDuration, forKey: "totalAppUsageMinutes")
    }
}

