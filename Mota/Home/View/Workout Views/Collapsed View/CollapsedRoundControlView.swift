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
    
    struct AsyncPreviewView: View {
        @State var loadingExercises = true
        @State var collapsedSuperset: CollapsedSuperset?
        
        var body: some View {
            if loadingExercises {
                ProgressView("loading exercises")
                    .task {
                        await SharedDatabase.preview.loadExercises()
                        let descriptor = FetchDescriptor<DatabaseExercise>(
                            predicate: #Predicate {
                                $0.id.localizedStandardContains("Barbell_Squat") ||
                                $0.id.localizedStandardContains("Barbell_Deadlift") ||
                                $0.id.localizedStandardContains("Barbell_Bench_Press_-_Medium_Grip") ||
                                $0.id.localizedStandardContains("Seated_Cable_Rows")
                            }
                        )
                        do {
                            let exercises = try await SharedDatabase.preview.database.fetch(descriptor)
                        } catch {
                            print(error)
                        }
                        let superset = SupersetNew(
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
                        await SharedDatabase.preview.database.insert(superset)
                        collapsedSuperset = CollapsedSuperset(superset: superset)
                        loadingExercises = false
                    }
            } else {
                if let collapsedSuperset {
                    CollapsedRoundControlView(collapsedSuperset: .constant(collapsedSuperset))
                } else {
                    Text("No superset found.")
                }
            }
        }
    }
    
    return AsyncPreviewView()
        .environment(\.database, SharedDatabase.preview.database)
    
}
