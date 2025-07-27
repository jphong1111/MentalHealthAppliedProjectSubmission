//
//  SoliUFont.swift
//  MentalHealth
//
//

import Foundation
import UIKit

final class SoliUFont: UIFont, @unchecked Sendable {
    enum FontType: String {
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
        case black = "Roboto-Black"
    }

    static let regular8 = SoliUFont(.regular, size: 8)
    static let regular10 = SoliUFont(.regular, size: 10)
    static let regular12 = SoliUFont(.regular, size: 12)
    static let regular14 = SoliUFont(.regular, size: 14)
    static let regular16 = SoliUFont(.regular, size: 16)
    static let regular18 = SoliUFont(.regular, size: 18)
    static let regular20 = SoliUFont(.regular, size: 20)
    
    static let medium10 = SoliUFont(.medium, size: 10)
    static let medium12 = SoliUFont(.medium, size: 12)
    static let medium14 = SoliUFont(.medium, size: 14)
    static let medium16 = SoliUFont(.medium, size: 16)
    static let medium18 = SoliUFont(.medium, size: 18)
    static let medium20 = SoliUFont(.medium, size: 20)
    
    static let bold10 = SoliUFont(.bold, size: 10)
    static let bold12 = SoliUFont(.bold, size: 12)
    static let bold14 = SoliUFont(.bold, size: 14)
    static let bold16 = SoliUFont(.bold, size: 16)
    static let bold18 = SoliUFont(.bold, size: 18)
    static let bold20 = SoliUFont(.bold, size: 20)
    static let bold22 = SoliUFont(.bold, size: 22)
    static let bold24 = SoliUFont(.bold, size: 24)
    static let bold32 = SoliUFont(.bold, size: 32)
    
    static let black10 = SoliUFont(.black, size: 10)
    static let black12 = SoliUFont(.black, size: 12)
    static let black14 = SoliUFont(.black, size: 14)
    static let black16 = SoliUFont(.black, size: 16)
    static let black32 = SoliUFont(.black, size: 32)
    
    private static func SoliUFont(_ type: FontType, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            print("Failed to load font: \(type.rawValue). Reverting to system font.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
