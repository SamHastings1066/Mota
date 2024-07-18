//
//  SelectExerciseScreen.swift
//  Mota
//
//  Created by sam hastings on 16/05/2024.
//

import SwiftUI
import SwiftData

struct SelectExerciseScreen: View {
    //TODO: prefer my original approach for filtering since this doesn't require multiple fetches from the database
    
    @Binding var selectedExercise: DatabaseExercise?
    @State var exerciseToBePresented: DatabaseExercise?
    @Environment(\.dismiss) private var dismiss
    //@Query(sort: \DatabaseExercise.name, order: .forward) private var exercises: [DatabaseExercise]
    @State var filterString: String = ""
    
    @Environment(\.database) private var database
    @State private var backgroundExercises: [DatabaseExercise] = []
    
    var filteredBackgroundExercises: [DatabaseExercise] {
        if filterString.isEmpty {
            return backgroundExercises
        } else {
            return backgroundExercises.filter { exercise in
                exercise.name.lowercased().contains(filterString.lowercased())
            }
        }
    }
    
//    var filteredExercises: [DatabaseExercise] {
//        if filterString.isEmpty {
//            return exercises
//        } else {
//            return exercises.filter { exercise in
//                exercise.name.lowercased().contains(filterString.lowercased())
//            }
//        }
//    }

    
    var body: some View {
        NavigationStack {
            if let currentExerciseName = selectedExercise?.name {
                Text("Current selection: \(currentExerciseName)")
                    .padding(.leading)
            }
            List {
                ForEach(filteredBackgroundExercises) { exercise in
                    Button {
                        selectedExercise = exercise
                        dismiss()
                    } label: {
                        ExerciseRowView(exercise: exercise)
                            //.logCreation()
                    }
                    .swipeActions {
                        Button("Info") {
                            exerciseToBePresented = exercise
                        }
                        .tint(.blue)
                    }
                }
            }
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
            .navigationTitle("Select exercise")
            .task {
                do {
                    let descriptor = FetchDescriptor<DatabaseExercise>(sortBy: [ SortDescriptor(\.name, order: .forward)])
                    backgroundExercises = try await database.fetch(descriptor)
                } catch {
                    print(error)
                }
            }

        }
        .searchable(text: $filterString, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            Button("Cancel") {
                dismiss()
            }
        }
        .sheet(item: $exerciseToBePresented) { exercise in
            ExerciseDetailView(exercise: exercise)
        }
    }
}



#Preview {
    
    struct AsyncPreviewView: View {
        @State var loadingExercises = true
        
        var body: some View {
            if loadingExercises {
                ProgressView("loading exercises")
                    .task {
                        await SharedDatabase.preview.loadExercises()
                        loadingExercises = false
                    }
            } else {
                SelectExerciseScreen(selectedExercise: .constant(nil))
            }
        }
    }
    
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
//        // check we haven't already added the exercises
//        let descriptor = FetchDescriptor<DatabaseExercise>()
//        let existingExercises = try container.mainContext.fetchCount(descriptor)
//        guard existingExercises == 0 else { 
//            return 
//            //NavigationStack {
//                SelectExerciseScreen(selectedExercise: .constant(nil))
//                    .modelContainer(container)
//            //}
//        }
//        
//        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
//            fatalError("Failed to find exercises.json")
//        }
//        let data = try Data(contentsOf: url)
//        let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: data)
//        for exercise in exercises {
//            container.mainContext.insert(exercise)
//        }
//        print("DATABASE created")
        
        
            return 
        //NavigationStack {
        AsyncPreviewView()
            .environment(\.database, SharedDatabase.preview.database)
            //.modelContainer(container)
        //}
//    } catch {
//        fatalError("Failed to create model container")
//    }
}
