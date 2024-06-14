//
//  SupersetNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI
import SwiftData

struct SupersetNewView: View {
    
    @Bindable var superset: SupersetNew
    @State var isExpanded: Bool
    @State private var isEditable : Bool
    @State var collapsedSuperset: CollapsedSuperset
    @State var collapsedSinglesets: [CollapsedSingleset] = []
    
    var orderedSupersets: [SupersetNew]
    var removeSupsersetClosure: (() -> Void)?
        
    init(superset: SupersetNew, isExpanded: Bool = false, isEditable: Bool = false, orderedSupersets: [SupersetNew], removeSupersetClosure: (() -> Void)? = nil) {
        let start = Date()
        self.superset = superset
        self.isExpanded = isExpanded
        self.isEditable = isEditable
        self.orderedSupersets = orderedSupersets
        self.collapsedSuperset = CollapsedSuperset(superset: superset)
        //self.collapsedSinglesets = CollapsedSuperset(superset: superset).collapsedSinglesets
        self.removeSupsersetClosure = removeSupersetClosure
        
        //print(collapsedSuperset.numRounds)
        print("SupersetNewView init takes \(Date().timeIntervalSince(start))s")
    }
    
    var index: Int {
        if let index = orderedSupersets.firstIndex(where: { $0.id == superset.id }) {
            return index
        } else {
            return 0
        }
    }
    
    var body: some View {
        // TODO: Make the work done in this view async, and make the work done in a more time efficient
        SupersetHeaderNewView(isExpanded: $isExpanded, isEditable: $isEditable, index: index){
         removeSupsersetClosure?()
        }
            .logCreation()
            if isExpanded {
                ForEach(superset.orderedRounds) { round in
                    ExpandedRoundNewView(round: round, isEditable: $isEditable)
                        .logCreation()
                }
            } else {
                HStack {
                    VStack {
                        ForEach(collapsedSinglesets) { collapsedSingleset in
                        //ForEach(collapsedSuperset.collapsedSinglesets) { collapsedSingleset in // THIS IS THE LINE
                            CollapsedSinglesetView(collapsedSingleset: collapsedSingleset){
                                collapsedSuperset.removeSingleSet(collapsedSingleset)
                                collapsedSuperset = CollapsedSuperset(superset: collapsedSuperset.superset)
                            }
                                .logCreation()
                        }.logCreation()
                        // TODO: Make the work done in this view async, and make the work done in a more time efficient
                        CollapsedRoundControlView(collapsedSuperset: $collapsedSuperset)
                            .logCreation()
                    }.logCreation()
                    // TODO: Make the work done in this view async, and make the work done in a more time efficient
                    CollapsedRoundInfoView(collapsedSuperset: $collapsedSuperset)
                        .padding()
                        .logCreation()
                }
                .onAppear{
                    Task {
                        // TODO: make this async
                        collapsedSinglesets = await collapsedSuperset.generateSinglesets(from: superset.orderedRounds)
                    }
                }
            }
    }
        
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let workout2 = WorkoutNew(name: "Arms workout",
            supersets: [
                SupersetNew(
                    rounds: [
                        Round(
                            singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                            rest:  60
                        ),
                        Round(
                            singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 90, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                            rest:  70
                        )
                    ]
                ),
                SupersetNew(
                    rounds: [
                        Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[2], weight: 10, reps: 20)]),
                    ]
                )
            ]
        )
        
        container.mainContext.insert(workout2)
        
        return Group {
//            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: true, orderedSupersets: workout2.orderedSupersets)
//                .modelContainer(container)
            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: false, orderedSupersets: workout2.orderedSupersets)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
