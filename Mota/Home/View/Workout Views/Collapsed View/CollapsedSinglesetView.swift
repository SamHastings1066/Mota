//
//  CollapsedSinglesetView.swift
//  Mota
//
//  Created by sam hastings on 19/04/2024.
//

import SwiftUI
import SwiftData

struct CollapsedSinglesetView: View {
    
    @Bindable var collapsedSingleset: CollapsedSingleset
    var removeSinglesetClosure: (() -> Void)?
    @State private var isExerciseDetailPresented = false
    @Environment(\.database) private var database
 
    var body: some View {
        HStack {
            
            VStack {
                ExerciseImageView(exercise: collapsedSingleset.exercise).frame(width: 70, height: 70)
                DeleteItemButton {
                    removeSinglesetClosure?()
                }
            }
            
            Grid {
                Text(collapsedSingleset.exercise?.name ?? "")
                    .font(.headline)
                GridRow {
                    VStack {
                        Text("Reps")
                        
                        TextField("", value: $collapsedSingleset.reps, formatter: NumberFormatter(), onEditingChanged: saveDatabase)
                            .fixedSize()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                    }
                    VStack {
                        Text("kgs")
                        
                        TextField("", value: $collapsedSingleset.weight, formatter: NumberFormatter(), onEditingChanged: saveDatabase)
                            .fixedSize()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                    }
                }
            }
            Spacer()
            
            
        }
        .padding([.vertical, .leading], 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
    
    private func saveDatabase(focused: Bool) {
        if focused == false {
            Task { try? await database.save() }
        }
    }
}

#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutTemplate.self, configurations: config)
//        
//        let singlesetRound1 = SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10)
//        let singlesetRound2 = SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 15)
//        let superset = SupersetNew(rounds: [Round(singlesets: [singlesetRound1]), Round(singlesets: [singlesetRound2])])
//                            
//        container.mainContext.insert(superset)
//        
//        
//        let collapsedSuperset = CollapsedSuperset(superset: superset)
//        
//        return Group {
//            CollapsedSinglesetView(collapsedSingleset: collapsedSuperset.collapsedSinglesets[0])
//        }
//    } catch {
//        fatalError("Failed to create model container")
//    }
    return AsyncPreviewView(
        asyncTasks: {
            await SharedDatabase.preview.loadExercises()
            let workout =  await SharedDatabase.preview.loadDummyWorkoutTemplate()
            return workout
        },
        content: { workout in
            if let workout = workout as? WorkoutTemplate {
                let superset = workout.orderedSupersets[0]
                let collapsedSuperset = CollapsedSuperset(superset: superset)
                Group {
                    CollapsedSinglesetView(collapsedSingleset: collapsedSuperset.collapsedSinglesets[0])
                }
            } else {
                Text("No workout found.")
            }
        }
    )
    .environment(\.database, SharedDatabase.preview.database)
}
