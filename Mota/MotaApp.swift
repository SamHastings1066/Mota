//
//  MotaApp.swift
//  Mota
//
//  Created by sam hastings on 17/01/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import SwiftData



// TODO: delete unused files and clean up names of files:
// delete the old ViewModel folder
// - LoginViewModel -> AuthenticationViewModel
// - Remove the AuthService as it is not longer needed

// TODO: Add sign in with google, sign in with apple

//TODO: remove the authenticated case since this is no longer used to determine whether a user is authenticated - the existemce of currentUser is

@main
struct MotaApp: App {
    
    var authService: AuthenticationService
    
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
            content
        }
        .modelContainer(for: [Workout.self, SuperSet.self, DatabaseExercise.self])
    }
    
    var content: AnyView {
        switch authService.loggedIn {
        case false:
            return AnyView(AuthenticationView(viewModel: LoginViewModel(authService: authService)))
        case true:
            return AnyView(HomeView(viewModel: HomeViewModel(authService: authService)))
        default:
            // TODO: Create better loading screen. Possibly the Mota Icon?
            return AnyView(Text("LOADING..."))
        }
    }
}
