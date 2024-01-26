//
//  MotaApp.swift
//  Mota
//
//  Created by sam hastings on 17/01/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth



// TODO: Update UI tests so that I have both an end-to-end test that uses teh firebase emulator and a pure UI test that uses a mock service
// Think about how I can switch the using the mock service if the env variable is test.
// Create another file called LoginEndToEndTests and a new EndToEndTestCase that launches with an "endtoend" var set. These tests should use the real firebase instance
// Move all of your current tests in LoginUItests file into this new file. Keep only the test_should_navigate_to_home_screen_when_authenticated test in the LoginUITest file


// TODO: delete unused files and clean up names of files:
// delete the old ViewModel folder
// - LoginViewModel -> AuthenticationViewModel
// - Remove the AuthService as it is not longer needed

// TODO: Add sign in with google, sign in with apple

//TODO: remove the authenticated case since this is no longer used to determine whether a user is authenticated - the existemce of currentUser is

@main
struct MotaApp: App {
    
    //@State var authService: AuthenticationService = FirebaseAuthService()

    //@State var authService: FirebaseAuthService = FirebaseAuthService()
    var authService: AuthenticationService
    //var homeViewModel: HomeViewModel
    
    init() {
        FirebaseApp.configure()
        #if targetEnvironment(simulator)
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        #endif
        
        if ProcessInfo.processInfo.arguments.contains("UITest") {
            #if DEBUG
            authService = MockAuthService()
            #else
            fatalError("MockAuthService should not be included in production builds.")
            #endif
        } else {
            authService = FirebaseAuthService()
        }
        
//        authService = FirebaseAuthService()
        
        if CommandLine.arguments.contains("reset") {
            // Ensure app launches in logged out state
            do {
                try authService.signOut()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // TODO: authservice to MockService if "mockService" env variable is set
        
    }
    
    var body: some Scene {
        WindowGroup {
            if authService.currentUser != nil {
                HomeView(viewModel: HomeViewModel(authService: authService))
                //.environment(authService as? MockAuthService)
            } else {
                AuthenticationView(viewModel: LoginViewModel(authService: authService))
            }
        }
    }
}
