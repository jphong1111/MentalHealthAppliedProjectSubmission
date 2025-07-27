//
//  BaseTabBarController.swift
//  MentalHealth
//
//

import UIKit
import FirebaseAnalytics

open class BaseTabBarController: UITabBarController {
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if LoginManager.shared.isGuestUser {
            Analytics.logEvent("guest_view_screen", parameters: [
                "screen": String(describing: type(of: self)),
                "timestamp": Date().timeIntervalSince1970
            ])
        }
    }
}
