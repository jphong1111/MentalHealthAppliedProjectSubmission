//
//  AppDelegate.swift
//  MentalHealth
//
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        LocalNotificationManager.shared.grantAccessAndScheduleIfAllowed()

        return true
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
        
    }
}

//// MARK: - UIWindow Extension for Debugging
//#if DEBUG
//import DebugPanel
//
//extension UIWindow {
//    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        guard motion == .motionShake else { return }
//
//        if let rootVC = self.rootViewController {
//            let debugVC = DebugPanelViewController()
//            let nav = UINavigationController(rootViewController: debugVC)
//            nav.modalPresentationStyle = .formSheet
//            rootVC.present(nav, animated: true)
//        }
//    }
//}
//#endif
