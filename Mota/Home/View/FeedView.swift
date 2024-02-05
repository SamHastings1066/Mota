//
//  FeedView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI

struct FeedView: View {
        
    var viewModel: FeedViewModel

    
    var body: some View {
        NavigationStack {
            VStack {
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
    var viewModel = FeedViewModel(authService: FirebaseAuthService())
    return FeedView(viewModel: viewModel)
}
