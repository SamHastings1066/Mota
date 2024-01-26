//
//  HomeView.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    //var username = AuthService.shared.currentUser?.email
    
    var viewModel: HomeViewModel
    //@Environment(FirebaseAuthService.self) var authService
    
//    var authService: AuthenticationService
//    
//    if ProcessInfo.processInfo.arguments.contains("UITest") {
//        @Environment(MockAuthService.self) var authService
//    } else {
//        @Environment(FirebaseAuthService.self) var authService
//    }
    
    var body: some View {
        NavigationStack {
            VStack {
                //Text("You're logged in as \(username ?? "").")
                Text("You're logged in as \(viewModel.authService.currentUser?.email ?? "").")
                    .accessibilityIdentifier("homeScreenGreetingText")
                NavigationLink("View Profile") {
                    UserView(viewModel: UserViewModel(authService: viewModel.authService))
                }
            }
        }
    }
}

#Preview {
    var viewModel = HomeViewModel(authService: FirebaseAuthService())
    return HomeView(viewModel: viewModel)
}
