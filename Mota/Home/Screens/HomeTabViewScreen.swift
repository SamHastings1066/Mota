//
//  HomeView.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import SwiftUI
import SwiftData

struct HomeTabViewScreen: View {
        
    var viewModel: HomeViewModel
    
    var body: some View {
        TabView {
            FeedScreen(viewModel: FeedViewModel(authService: viewModel.authService))
                .tabItem {
                    Label("Users", systemImage: "person.2.fill")
                }
            WorkoutCalendarScreen()
                .tabItem {
                    Label("Log", systemImage: "calendar")
                }
            WorkoutListNewScreen()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
            UserScreen(viewModel: UserViewModel(authService: viewModel.authService))
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    
    let viewModel = HomeViewModel(authService: FirebaseAuthService())
    return AsyncPreviewView(
        asyncTasks: {
            await SharedDatabase.preview.loadExercises()
            return nil
        },
        content: { _ in
            HomeTabViewScreen(viewModel: viewModel)
        }
    )
    .environment(\.database, SharedDatabase.preview.database)
    


}
