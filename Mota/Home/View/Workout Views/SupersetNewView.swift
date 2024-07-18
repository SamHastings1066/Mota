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
        self.removeSupsersetClosure = removeSupersetClosure
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
        // TODO: Make the work done in this view more time efficient
        SupersetHeaderNewView(isExpanded: $isExpanded, isEditable: $isEditable, index: index){
         removeSupsersetClosure?()
        }
            if isExpanded {
                ForEach(superset.orderedRounds) { round in
                    ExpandedRoundNewView(round: round, isEditable: $isEditable)
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
                        }
                        // TODO: Make the work done in this view more time efficient
                        CollapsedRoundControlView(collapsedSuperset: $collapsedSuperset)
                    }
                    // TODO: Make the work done in this view more time efficient
                    CollapsedRoundInfoView(collapsedSuperset: $collapsedSuperset)
                        .padding()
                }
                .onAppear{
                    Task {
                        collapsedSinglesets = await collapsedSuperset.generateSinglesets(from: superset.orderedRounds)
                    }
                }
                // TODO: Using .onChange here fixes the problem that collapsedSinglesets is used in the ForEach instead of directly using collapsedSuperset.collapsedSinglesets. CollapsedRoundInfoView makes changes to collapsedSuperset, therefore must use .onChange to watch for these changes and then ensure that collapsedSinglesets is updated separately. The reason why collapsedSinglesets is used in the ForEach instead of directly using collapsedSuperset.collapsedSinglesets is so that collapsedSinglesets can be generated asynchronously because it is a time consuming operation. The better solution is to make the generation of collapsedSinglesets quick. There is no reason for it to take so long that it causes a hang if performed synchronously.
                .onChange(of: collapsedSuperset) { _, _ in
                    Task {
                        collapsedSinglesets = await collapsedSuperset.generateSinglesets(from: superset.orderedRounds)
                    }
                }
            }
    }
        
}

#Preview {
    // TODO: update this preview to use background database
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        var rounds = [Round]()
        for _ in 0..<2000 {
            let round = Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)])
            rounds.append(round)
        }
        let workout1 = WorkoutNew(
            name: "Legs workout",
            supersets: [
                SupersetNew(
                    rounds: rounds
                )
            ]
        )
        
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
        
        container.mainContext.insert(workout1)
        
        return Group {
//            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: true, orderedSupersets: workout2.orderedSupersets)
//                .modelContainer(container)
            SupersetNewView(superset: workout1.orderedSupersets[0], isExpanded: false, orderedSupersets: workout1.orderedSupersets)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
