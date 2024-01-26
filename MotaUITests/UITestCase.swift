//
//  UITestCase.swift
//  MotaUITests
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation
import XCTest

class UITestCase: XCTestCase {
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
        app.launchEnvironment = ["ENV": "TEST"]
        app.launchArguments = ["reset", "UITest"]
        app.launch()
    }
    
//        override func tearDown() {
//            
//            // Take a screenshot of the app whenever the test finishes its work; keep the screenshot only for failing tests to help understand what went wrong.
    // This isn't needed any more; Xcode records the test automatically.
//            let screenshot = XCUIScreen.main.screenshot()
//            let attachment = XCTAttachment(screenshot: screenshot)
//            attachment.lifetime = .deleteOnSuccess
//            add(attachment)
//            
//            app.terminate()
//        }

    
}
