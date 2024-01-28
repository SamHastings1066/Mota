//
//  EndToEndTestCase.swift
//  MotaUITests
//
//  Created by sam hastings on 27/01/2024.
//

import Foundation
import XCTest

class EndToEndTestCase: XCTestCase {
    var app: XCUIApplication!
    var loginPageObject: LoginPageObject!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        loginPageObject = LoginPageObject(app: app)
        continueAfterFailure = false
        
        // Set the device orientation to portrait
        XCUIDevice.shared.orientation = .portrait
        
        // Every time a test from this class is run, this Env varibale is passed to the application.
        app.launchArguments = ["reset", "EndToEndTest"]
        app.launch()
    }
    

    
}
