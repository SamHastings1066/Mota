//
//  HomeView.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    var username = AuthService.shared.currentUser?.email
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("You're logged in as \(username ?? "").")
                    .accessibilityIdentifier("homeScreenGreetingText")
                NavigationLink("View Profile") {
                    UserView(viewModel: UserViewModel())
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
