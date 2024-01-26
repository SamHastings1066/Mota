//
//  HomePageObject.swift
//  MotaUITests
//
//  Created by sam hastings on 24/01/2024.
//

import Foundation
import XCTest

struct HomePageObject: PageObject {
    let app: XCUIApplication
    
    private enum Identifiers {
        static let homeScreenGreetingText = "homeScreenGreetingText"
    }
    
    func verifyGreetingTextExists() -> Self {
        let homeScreenGreetingText = app.staticTexts[Identifiers.homeScreenGreetingText]
        XCTAssertTrue(homeScreenGreetingText.waitForExistence(timeout: 0.5))
        return self
        
    }
}
