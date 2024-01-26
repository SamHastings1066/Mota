//
//  LoginPageObject.swift
//  MotaUITests
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation
import XCTest

protocol PageObject {
    var app: XCUIApplication { get }
}

struct LoginPageObject: PageObject {
    let app: XCUIApplication
    
    private var emailTextField: XCUIElement {
        app.textFields["loginEmailTextField"]
    }
    
    private var passwordSecureTextField: XCUIElement {
        app.secureTextFields["loginPasswordSecureTextField"]
    }
    
    private var loginButton: XCUIElement {
        app.buttons["loginLoginButton"]
    }
    
    private var signupButton: XCUIElement {
        app.buttons["signupButton"]
    }
    
    private var errorMessageText: XCUIElement {
        app.staticTexts["loginErrorMessageText"]
    }
    
    func typePassword(_ password: String) -> Self {
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        return self
    }
    
    func typeEmail(_ email: String) -> Self {
        emailTextField.tap()
        emailTextField.typeText(email)
        return self
    }
    
    func verifyLoginButtonIsDisabled() -> Self {
        XCTAssertTrue(loginButton.isEnabled == false)
        return self
    }
    
    func tapLoginExpectingErrorMessageText(_ expectedErrorMessage: String) -> Self {
        loginButton.tap()
        XCTAssertEqual(errorMessageText.label, expectedErrorMessage)
        return self
    }
    
    func tapLogin() -> HomePageObject {
        loginButton.tap()
        return HomePageObject(app: app)
    }
    
    func tapSignupButton() -> SignupPageObject {
        signupButton.tap()
        return SignupPageObject(app: app)
    }
    
}
