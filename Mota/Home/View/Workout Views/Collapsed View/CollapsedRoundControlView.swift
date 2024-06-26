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
//        .popover(item: $selectedSuperSet) { _ in
//            RearrangeExerceriseRoundsView(superSet: superSet)
//        }
        .fullScreenCover(isPresented: $isAddExercisePresented,
                         onDismiss: {
            if let addedExercise = addedExercise {
                collapsedSuperset.addSingleset(with: addedExercise)
                let newCollapsedSuperset = CollapsedSuperset(superset: collapsedSuperset.superset)
                collapsedSuperset = newCollapsedSuperset
            }
            addedExercise = nil
        },
                         content: {
            SelectExerciseScreen(selectedExercise: $addedExercise)
        })
//        .onChange(of: addedExercise, { _, _ in
//            // TODO: Change this approach. collapsedSuperset is a Binding, therefore changing it will not update the view. must use a change in the isAddExercisePresented State var to update the view when an exercise is added.
//        })
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let superset1 = SupersetNew(
            rounds: [
                Round(
                    singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                    rest:  60
                ),
                Round(
                    singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 90, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                    rest:  60
                )
            ]
        )
        let collapsedSuperset1 = CollapsedSuperset(superset: superset1)
        
        container.mainContext.insert(superset1)
        
        return CollapsedRoundControlView(collapsedSuperset: .constant(collapsedSuperset1))
                                         
    } catch {
        fatalError("Failed to create model container")
    }
    
}
