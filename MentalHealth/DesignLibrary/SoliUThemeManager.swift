//
//  SoliUThemeManager.swift
//  MentalHealth
//
//

import UIKit

final class SoliUThemeManager {
    static let shared = SoliUThemeManager()

    var currentState: MentalHealthState = .normal

    private init() {} // Enforce Singleton

    func updateMentalHealthState(_ newState: MentalHealthState) {
        currentState = newState
    }
}

enum MentalHealthState {
    case normal
    case depression
    case anxiety
    case stress
    case burnout
    case loneliness

    /// Returns the associated background color for each state
    var backgroundColor: UIColor {
        switch self {
        case .normal: return SoliUColor.neutralBlue
        case .depression: return SoliUColor.calmPurple
        case .anxiety: return SoliUColor.relaxingGreen
        case .stress: return SoliUColor.warmOrange
        case .burnout: return SoliUColor.soothingGray
        case .loneliness: return SoliUColor.comfortYellow
        }
    }

    /// Returns the associated text color for each state
    var textColor: UIColor {
        switch self {
        case .normal: return .black
        case .depression: return .white
        case .anxiety: return .darkGray
        case .stress: return .white
        case .burnout: return .black
        case .loneliness: return .darkGray
        }
    }
}

#if DEBUG
extension SoliUThemeManager {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: SoliUThemeManager

        var currentState: MentalHealthState { target.currentState }

        func updateMentalHealthState(_ newState: MentalHealthState) {
            target.updateMentalHealthState(newState)
        }
    }
}
#endif
