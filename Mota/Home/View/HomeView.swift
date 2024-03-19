//
//  HomeView.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import SwiftUI

struct HomeView: View {
        
    var viewModel: HomeViewModel

    
    var body: some View {
        TabView {
            FeedView(viewModel: FeedViewModel(authService: viewModel.authService))
                .badge(2)
                .tabItem {
                    Label("Users", systemImage: "tray.and.arrow.down.fill")
                }
            WorkoutListScreen()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .navigationTitle("My Title")
            UserView(viewModel: UserViewModel(authService: viewModel.authService))
                .badge("!")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    var viewModel = HomeViewModel(authService: FirebaseAuthService())
    return HomeView(viewModel: viewModel)
}
