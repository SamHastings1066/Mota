//
//  SignupPageObject.swift
//  MotaUITests
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation
import XCTest

struct SignupPageObject: PageObject {
    let app: XCUIApplication
    
    var signUpTitle: XCUIElement {
        app.staticTexts["signUpTitle"]
    }
    
    func verifySignUpTitleExists() -> Self {
        XCTAssertTrue(signUpTitle.waitForExistence(timeout: 0.5))
        return self
    }
}
