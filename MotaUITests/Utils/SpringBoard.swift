//
//  SpringBoard.swift
//  MotaUITests
//
//  Created by sam hastings on 24/01/2024.
//

import Foundation
import XCTest

class SpringBoard {
    
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    class func deleteApp() {
        XCUIApplication().terminate()
        springboard.activate()
        
        let appIcon = springboard.icons.matching(identifier: "Mota").firstMatch
        appIcon.press(forDuration: 1.3)
        
        let _ = springboard.buttons["Remove App"].waitForExistence(timeout: 1.0)
        springboard.buttons["Remove App"].tap()
        
        let deletedButton = springboard.alerts.buttons["Delete App"].firstMatch
        if deletedButton.waitForExistence(timeout: 1.0) {
            deletedButton.tap()
            let finalDeleteButton = springboard.alerts.buttons["Delete"]
            if finalDeleteButton.waitForExistence(timeout: 1.0) {
                finalDeleteButton.tap()
            }
        }
    }
}
