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
    //@State var collapsedSinglesets: [CollapsedSingleset] = []
    @Environment(\.database) private var database
    @State var changed = false
    
    var orderedSupersets: [SupersetNew]
    var removeSupsersetClosure: (() -> Void)?
    
    init(superset: SupersetNew, isExpanded: Bool = false, isEditable: Bool = false, orderedSupersets: [SupersetNew], removeSupersetClosure: (() -> Void)? = nil) {
        //let start = Date()
        self.superset = superset
        self.isExpanded = isExpanded
        self.isEditable = isEditable
        self.orderedSupersets = orderedSupersets
        self.collapsedSuperset = CollapsedSuperset(superset: superset)
        self.removeSupsersetClosure = removeSupersetClosure
        //print("SupersetNewView init takes \(Date().timeIntervalSince(start))s")
    }
    
    var index: Int {
        if let index = orderedSupersets.firstIndex(where: { $0.id == superset.id }) {
            return index
        } else {
            return 0
        }
    }
    
    var body: some View {
        VStack {
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
                        //ForEach(collapsedSinglesets) { collapsedSingleset in
                            ForEach(collapsedSuperset.collapsedSinglesets) { collapsedSingleset in // THIS IS THE LINE that is slow
                            CollapsedSinglesetView(collapsedSingleset: collapsedSingleset){
                                collapsedSuperset.removeSingleSet(collapsedSingleset)
                                collapsedSuperset = CollapsedSuperset(superset: collapsedSuperset.superset)
                                Task {
                                    try? await database.save()
                                }
                            }
                        }
                        // TODO: Make the work done in this view more time efficient
                        CollapsedRoundControlView(collapsedSuperset: $collapsedSuperset)
                    }
                    // TODO: Make the work done in this view more time efficient
                    CollapsedRoundInfoView(collapsedSuperset: $collapsedSuperset)
                        .padding()
                }
//                .onAppear{
//                    Task {
//                        collapsedSinglesets = await collapsedSuperset.generateSinglesets(from: superset.orderedRounds)
//                    }
//                }
                // TODO: Using .onChange here fixes the problem that collapsedSinglesets is used in the ForEach instead of directly using collapsedSuperset.collapsedSinglesets. CollapsedRoundInfoView makes changes to collapsedSuperset, therefore must use .onChange to watch for these changes and then ensure that collapsedSinglesets is updated separately. The reason why collapsedSinglesets is used in the ForEach instead of directly using collapsedSuperset.collapsedSinglesets is so that collapsedSinglesets can be generated asynchronously because it is a time consuming operation. The better solution is to make the generation of collapsedSinglesets quick. There is no reason for it to take so long that it causes a hang if performed synchronously.
//                .onChange(of: collapsedSuperset) { _, _ in
//                    // print("ONCE") // this happens multiple times and since shared mutable state of CollapsedSuperset is being concurrently manipulated the function causes an error data races occur
//                    Task {
//                        collapsedSinglesets = await collapsedSuperset.generateSinglesets(from: superset.orderedRounds)
//                    }
//                }
            }
        }
    }
    
}

#Preview {

    return NavigationStack {
        AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkoutTemplate()
                return workout
            },
            content: { workout in
                if let workout = workout {
                    SupersetNewView(superset: workout.orderedSupersets[0], isExpanded: false, orderedSupersets: workout.orderedSupersets)
                } else {
                    Text("No workout found.")
                }
            }
        )
    }
    .environment(\.database, SharedDatabase.preview.database)
}
