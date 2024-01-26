//
//  LoginUITests.swift
//  LoginUITests
//
//  Created by sam hastings on 17/01/2024.
//

import XCTest

final class LoginUITests: UITestCase {




    func test_should_disable_login_button_if_email_field_is_empty() {
        
        _ = LoginPageObject(app: app)
            .typePassword("123")
            .verifyLoginButtonIsDisabled()
    }
    
    func test_should_disable_login_button_if_password_field_is_empty() {
        _ = LoginPageObject(app: app)
            .typeEmail("Fatima")
            .verifyLoginButtonIsDisabled()
    }
    
    func test_should_display_error_message_if_login_attempted_with_badly_formatted_email() {
        
        _ = LoginPageObject(app: app)
            .typeEmail("Fatima")
            .typePassword("123")
            .tapLoginExpectingErrorMessageText("The email address is badly formatted.")
    }
    
    func test_should_display_error_message_if_login_attempted_with_unknown_user() {
        
        // N.B. The error message when using a real firebase instance is different than the message from the emulator instance.
        _ = LoginPageObject(app: app)
            .typeEmail("Fatima@gmail.com")
            .typePassword("123")
            .tapLoginExpectingErrorMessageText("There is no user record corresponding to this identifier. The user may have been deleted.")
    }
    
    func test_should_navigate_to_signup_screen_when_signup_button_tapped() {
        _ = LoginPageObject(app: app)
            .tapSignupButton()
            .verifySignUpTitleExists()
    }
    
    // This test should delete app at the end in orde to ensure it does not impact the state of the next test.
    func test_should_navigate_to_home_screen_when_authenticated() {
        
        _ = LoginPageObject(app: app)
            .typeEmail("sam@example.com")
            .typePassword("123456")
            .tapLogin()
            .verifyGreetingTextExists()
        
                
    }
    


}
