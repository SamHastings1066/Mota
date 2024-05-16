//
//  SelectExerciseScreen.swift
//  Mota
//
//  Created by sam hastings on 16/05/2024.
//

import SwiftUI
import SwiftData

struct SelectExerciseScreen: View {
    
    @State private var searchText = ""
    @Binding var selectedExercise: DatabaseExercise?
    
    var body: some View {
        Text("Selected exercise: \(selectedExercise?.name ?? "None")")
        ExerciseList(searchText: searchText, selectedExercise: $selectedExercise)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Select exercise")
    }
}

struct ExerciseList: View {
    @Query private var exercises: [DatabaseExercise]
    @State var exerciseToBePresented: DatabaseExercise?
    @Binding var selectedExercise: DatabaseExercise?
    @Environment(\.dismiss) private var dismiss
    
    init(searchText: String, selectedExercise: Binding<DatabaseExercise?>) {
        self._selectedExercise = selectedExercise
        _exercises = Query(
            filter: #Predicate {
                if searchText.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(searchText)
                }
            },
            sort: \DatabaseExercise.name,
            order: .forward
        )
    }
    
    var body: some View {
        Section(header: Text("Swipe left for more info")) {
            List {
                ForEach(exercises) { exercise in
                    Button {
                        selectedExercise = exercise
                        print(exercise.name)
                        dismiss()
                    } label: {
                        ExerciseRowView(exercise: exercise)
                    }
                    .swipeActions {
                        Button("Info") {
                            exerciseToBePresented = exercise
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .sheet(item: $exerciseToBePresented) { exercise in
                ExerciseDetailView(exercise: exercise)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        // check we haven't already added the exercises
        let descriptor = FetchDescriptor<DatabaseExercise>()
        let existingExercises = try container.mainContext.fetchCount(descriptor)
        guard existingExercises == 0 else { return 
            NavigationStack {
                SelectExerciseScreen(selectedExercise: .constant(nil)).modelContainer(container)
            }
        }
        
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
            fatalError("Failed to find exercises.json")
        }
        let data = try Data(contentsOf: url)
        let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: data)
        for exercise in exercises {
            container.mainContext.insert(exercise)
        }
        print("DATABASE created")
        
        
        return NavigationStack {
            SelectExerciseScreen(selectedExercise: .constant(nil))
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
