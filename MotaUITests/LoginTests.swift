//
//  MotaUITests.swift
//  MotaUITests
//
//  Created by sam hastings on 17/01/2024.
//

import XCTest

final class LoginTests: UITestCase {
    
    private var app: XCUIApplication!
    private var loginPageObject: LoginPageObject!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        loginPageObject = LoginPageObject(app: app)
        continueAfterFailure = false
        
        // Set the device orientation to portrait
        XCUIDevice.shared.orientation = .portrait
        
        // Every time a test from this class is run, this Env varibale is passed to the application.
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
    }

//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func test_should_disable_login_button_if_email_field_is_empty() {
        let passwordSecureTextField = loginPageObject.passwordSecureTextField
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123")
        
        let loginButton = loginPageObject.loginButton
        
        XCTAssertTrue(loginButton.isEnabled == false)
    }
    
    func test_should_disable_login_button_if_password_field_is_empty() {
        let emailTextField = loginPageObject.emailTextField
        emailTextField.tap()
        emailTextField.typeText("Fatima")
        
        let loginButton = loginPageObject.loginButton
        
        XCTAssertTrue(loginButton.isEnabled == false)
    }
    
    func test_should_display_error_message_if_login_attempted_with_badly_formatted_email() {
        
        let emailTextField = loginPageObject.emailTextField
        emailTextField.tap()
        emailTextField.typeText("Fatima.com")
        
        let passwordSecureTextField = loginPageObject.passwordSecureTextField
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123")
        
        let loginButton = loginPageObject.loginButton
        loginButton.tap()
        
        let errorMessageText = loginPageObject.errorMessageText
        
        XCTAssertEqual(errorMessageText.label, "The email address is badly formatted.")
        
    }
    
    func test_should_navigate_to_signup_screen_when_signup_button_tapped() {
        
    }
    
    func test_should_navigate_to_home_screen_when_authenticated() {
        
    }
    


}
