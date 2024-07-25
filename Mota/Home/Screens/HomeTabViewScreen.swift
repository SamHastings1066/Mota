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
            //WorkoutListScreen()
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
    
//    struct AsyncPreviewView: View {
//        @State var loadingExercises = true
//        var viewModel: HomeViewModel
//        
//        var body: some View {
//            if loadingExercises {
//                ProgressView("loading exercises")
//                    .task {
//                        await SharedDatabase.preview.loadExercises()
//                        loadingExercises = false
//                    }
//            } else {
//                HomeTabViewScreen(viewModel: viewModel)
//            }
//        }
//    }
    struct HomeTabViewSetup: AsyncSetup {
        func performSetup() async {
            await SharedDatabase.preview.loadExercises()
        }
        
    }
    
    var viewModel = HomeViewModel(authService: FirebaseAuthService())
//    return AsyncPreviewView(viewModel: viewModel).environment(\.database, SharedDatabase.preview.database)
    return AsyncPreviewView(setup: HomeTabViewSetup()) {
        HomeTabViewScreen(viewModel: viewModel)
    }
    .environment(\.database, SharedDatabase.preview.database)
}
