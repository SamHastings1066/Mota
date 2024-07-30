//
//  CollapsedRoundControlView.swift
//  Mota
//
//  Created by sam hastings on 19/04/2024.
//

import SwiftUI
import SwiftData

struct CollapsedRoundControlView: View {
    
    @Binding var collapsedSuperset: CollapsedSuperset
    @State private var isAddExercisePresented = false
    @State private var isRearrangeExercisesPresented = false
    @State private var addedExercise: DatabaseExercise? = nil
    @Environment(\.database) private var database
    
    var body: some View {
        
        HStack {
            Spacer()
            //if collapsedSuperset.collapsedSinglesets.count > 1 {
                Button {
                    // use .onTapGesture
                } label: {
                    Image(systemName: "arrow.up.arrow.down.square")
                        .imageScale(.large)
                }
                .onTapGesture {
                    isRearrangeExercisesPresented.toggle()
                    //selectedSuperSet = superSet
                }
            //}
            
            Button {
                
            } label: {
                Image(systemName: "plus")
            }
            .onTapGesture {
                isAddExercisePresented.toggle()
            }
            Spacer()
        }
        .padding(.top, 10)
        .popover(isPresented: $isRearrangeExercisesPresented, content: {
            RearrangeExerciseScreen(collapsedSuperset: collapsedSuperset)
        })
        .fullScreenCover(isPresented: $isAddExercisePresented,
                         onDismiss: {
            if let addedExercise = addedExercise {
                Task {
                    for roundIndex in collapsedSuperset.superset.orderedRounds.indices {
                        let newSingleset = SinglesetNew(exercise: addedExercise, weight: 0, reps: 0)
                        await database.insert(newSingleset)
                        // try? await database.update(collapsedSuperset.superset.rounds[roundIndex]) { round in
                        //      round.singlesets.append(newSingleset)
                        // }
                        // Or do it on Main Actor
                        collapsedSuperset.superset.orderedRounds[roundIndex].singlesets.append(newSingleset)
                        let newCollapsedSuperset = CollapsedSuperset(superset: collapsedSuperset.superset)
                        collapsedSuperset = newCollapsedSuperset
                    }
                    try? await database.save()
                }
            }
            addedExercise = nil
        },
                         content: {
            SelectExerciseScreen(selectedExercise: $addedExercise)
        })        
    }
}

#Preview {
    
    return AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkout()
                return workout
            },
            content: { workout in
                if let workout = workout as? WorkoutTemplate {
                    let superset = workout.orderedSupersets[0]
                    let collapsedSuperset = CollapsedSuperset(superset: superset)
                    CollapsedRoundControlView(collapsedSuperset: .constant(collapsedSuperset))
                } else {
                    Text("No workout found.")
                }
            }
        )
    .environment(\.database, SharedDatabase.preview.database)
    
}
