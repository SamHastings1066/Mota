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
    @State var loadingExercises = true
    
    var body: some View {
        if loadingExercises {
            ProgressView("loading exercises")
            // TODO: Consider moving this somewhere else higher up the view hierarchy
                .task {
                    do {
                        let descriptor = FetchDescriptor<DatabaseExercise>()
                        let existingExercises = try await database.fetchCount(fetchDescriptor: descriptor)
                        guard existingExercises == 0 else {
                            print("Exercises already exist")
                            loadingExercises = false
                            return
                        }
                        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
                            fatalError("Failed to find exercises.json")
                        }
                        let data = try Data(contentsOf: url)
                        let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: data)
                        for exercise in exercises {
                            await database.insert(exercise)
                        }
                        try await database.save()
                        print("Exercises created")
                        loadingExercises = false
                    } catch {
                        print("Exercises could not be created \(error)")
                    }
                }
        } else {
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
}

#Preview {
    var viewModel = HomeViewModel(authService: FirebaseAuthService())
    return HomeView(viewModel: viewModel).environment(\.database, SharedDatabase.preview.database)
}
