//
//  EditSupersetScreen.swift
//  Mota
//
//  Created by sam hastings on 15/05/2024.
//

import SwiftUI
import SwiftData

struct EditSupersetScreen: View {
    var collapsedSuperset: CollapsedSuperset
    var body: some View {
        ForEach(collapsedSuperset.collapsedSinglesets) { collapsedSingleset in
            Form {
                Text(collapsedSingleset.exercise?.name ?? "No exercise")
                SafeImageView(imageName: collapsedSingleset.imageName, fullSizeImageURL: nil)
                    .frame(width: 70, height: 70)
                HStack {
                    Text("Reps:")
                    TextField("Reps", value: Binding(get: {
                        collapsedSingleset.reps
                    }, set: { newValue in
                        collapsedSingleset.reps = newValue
                    }), formatter: NumberFormatter())
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                }
                HStack {
                    Text("Weight:")
                    TextField("Weight", value: Binding(get: {
                        collapsedSingleset.weight
                    }, set: { newValue in
                        collapsedSingleset.weight = newValue
                    }), formatter: NumberFormatter())
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                }
            }
        }
        
        
        
    }
}

#Preview {
    
        
    return AsyncPreviewView(
        asyncTasks: {
            await SharedDatabase.preview.loadExercises()
            return await SharedDatabase.preview.loadDummyWorkout()
        },
        content: { workout in
            if let workout = workout as? WorkoutNew {
                let superset = workout.orderedSupersets[0]
                EditSupersetScreen(collapsedSuperset: CollapsedSuperset(superset: superset))
            } else {
                Text("No superset found.")
            }
        }
    )
        .environment(\.database, SharedDatabase.preview.database)
    
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
//        
//        let superset = SupersetNew(
//            rounds: [
//                Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)])
//            ]
//        )
//        
//        container.mainContext.insert(superset)
//        
//        return NavigationStack {
//            EditSupersetScreen(collapsedSuperset: CollapsedSuperset(superset:  superset))
//                .modelContainer(container)
//        }
//    } catch {
//        fatalError("Failed to create model container")
//    }
}
