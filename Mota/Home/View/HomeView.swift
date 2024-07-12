//
//  HomeView.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
        
    var viewModel: HomeViewModel
    @Environment(\.database) private var database
    
    var body: some View {
        TabView {
            FeedView(viewModel: FeedViewModel(authService: viewModel.authService))
                .tabItem {
                    Label("Users", systemImage: "person.2.fill")
                }
            //WorkoutListScreen()
            WorkoutListNewScreen()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
            UserView(viewModel: UserViewModel(authService: viewModel.authService))
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    var viewModel = HomeViewModel(authService: FirebaseAuthService())
    return HomeView(viewModel: viewModel).environment(\.database, SharedDatabase.preview.database)
}
