//
//  CellReusable+Extension.swift
//  MentalHealth
//
//

import Foundation

import UIKit

protocol CellReusable {
    static var reuseIdentifier: String { get }
}

extension CellReusable {
    static var reuseIdentifier: String {
         String(describing: self)
    }
}

