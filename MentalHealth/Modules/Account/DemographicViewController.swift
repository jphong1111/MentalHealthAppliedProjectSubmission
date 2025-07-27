//
//  DemographicViewController.swift
//  MentalHealth
//
//

import Foundation
import UIKit

final class DemographicViewController: BaseViewController {
    @IBOutlet weak var ageTitleLabel: SoliULabel! {
        didSet {
            self.ageTitleLabel.text = .localized(.age)
        }
    }
    @IBOutlet weak var statusTitleLabel: SoliULabel! {
        didSet {
            self.statusTitleLabel.text = .localized(.currentStatus)
        }
    }
    @IBOutlet weak var ethnicityTitleLabel: SoliULabel! {
        didSet {
            self.ethnicityTitleLabel.text = .localized(.ethnicity)
        }
    }
    @IBOutlet weak var ageLabel: SoliULabel!
    @IBOutlet weak var statusLabel: SoliULabel!
    @IBOutlet weak var ethnicityLabel: SoliULabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SoliUColor.homepageBackground
        setCustomBackNavigationButton()
        setNavigationTitle(title: .localized(.demographics))
        
        /// This will not work if user continue logged in into the application
        if LoginManager.shared.isLoggedIn() {
            ageLabel.text = LoginManager.shared.getAge()
            statusLabel.text = LoginManager.shared.getWorkStatus()
            ethnicityLabel.text = LoginManager.shared.getEthnicity()
        } else {
            ageLabel.text = "N/A"
            statusLabel.text = "N/A"
            ethnicityLabel.text = "N/A"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

#if DEBUG
extension DemographicViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: DemographicViewController

        var ageTitleLabel: SoliULabel { target.ageTitleLabel }

        var statusTitleLabel: SoliULabel { target.statusTitleLabel }

        var ethnicityTitleLabel: SoliULabel { target.ethnicityTitleLabel }

        var ageLabel: SoliULabel { target.ageLabel }

        var statusLabel: SoliULabel { target.statusLabel }

        var ethnicityLabel: SoliULabel { target.ethnicityLabel }
    }
}
#endif
