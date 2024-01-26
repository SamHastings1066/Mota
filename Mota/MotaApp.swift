//
//  MotaApp.swift
//  Mota
//
//  Created by sam hastings on 17/01/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth



// TODO: delete unused files and clean up names of files:
// delete the old ViewModel folder
// - LoginViewModel -> AuthenticationViewModel

// TODO: Add sign in with google, sign in with apple

//TODO: remove the authenticated case since this is no longer used to determine whether a user is authenticated - the existemce of currentUser is

@main
struct MotaApp: App {
    
    //@State var authService: AuthenticationService
    @State var authService: FirebaseAuthService
    
    init() {
        FirebaseApp.configure()
        #if targetEnvironment(simulator)
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        #endif
        
        if CommandLine.arguments.contains("reset") {
            // Ensure app launches in logged out state
            AuthService.shared.currentUser = nil
        }
        authService = FirebaseAuthService()
    }
    
    var body: some Scene {
        WindowGroup {
            if AuthService.shared.currentUser != nil {
            //if authService.currentUser != nil {
                HomeView()
            } else {
                AuthenticationView()
                    .environment(authService)
            }
        }
    }
}
