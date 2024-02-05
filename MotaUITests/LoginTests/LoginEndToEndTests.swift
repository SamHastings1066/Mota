//
//  LoginEndToEndTests.swift
//  MotaUITests
//
//  Created by sam hastings on 27/01/2024.
//

import XCTest


/// Tests the login flow end-to-end using a firebase emulator instance in the authentication service .
final class LoginEndToEndTests: EndToEndTestCase {
    
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
    
    // This test should delete app at the end in order to ensure it does not impact the state of the next test.
    func test_should_navigate_to_home_screen_when_authenticated() {
        
        _ = LoginPageObject(app: app)
            .typeEmail("sam@example.com")
            .typePassword("123456")
            .tapLogin()
            .verifyGreetingTextExists()
        
                
    }
    


}
