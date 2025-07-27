////
////  XCUIElement+Extension.swift
////  MentalHealth
////
////
//
//import XCTest
//import Foundation
//
//extension TimeInterval {
//    public static let defaultWait: TimeInterval = 5.0
//}
//
//extension XCUIElement {
//    public func swipeUpUntilElementFound () -> Bool {
//        return true
//    }
//    
//    public func waitForExistence(timeout: TimeInterval, scrollingFrom fromElement: XCUIElement) -> Bool {
//        let found = exists || waitForExistence(timeout: timeout)
//        if !isHittable {
//            return fromElement.swipeUpUntilElementFound()
//        }
//        return found
//    }
//    
//    public func waitForExistence() -> Bool {
//        exists || waitForExistence(timeout: .defaultWait)
//    }
//}
