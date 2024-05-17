//
//  CollapsedRoundView.swift
//  Mota
//
//  Created by sam hastings on 19/04/2024.
//

//import SwiftUI
//import SwiftData
//
//struct CollapsedRoundView: View {
//    
//    @Bindable var round: Round
//    
//    var body: some View {
//        Text("Collapsed round view")
//    }
//}
//
//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
//        
//        let round = Round(
//            singlesets: [
//                SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10),
//                SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)
//            ],
//            rest: 60
//        )
//        
//        container.mainContext.insert(round)
//        
//        return CollapsedRoundView(round: round)
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}


//import SwiftUI
//import SwiftData
//
//struct CollapsedRoundView: View {
//    
//    @Binding var singlesets: [SinglesetNew]
//    
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
//        
//        let singleset1 = SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10)
//            let singleset2 = SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)
//
//        
//        let singlesets =  [
//                singleset1, singleset2
//            ]
//        
//        container.mainContext.insert(singleset1)
//        container.mainContext.insert(singleset2)
//        
//        return CollapsedRoundView(singlesets: .constant(singlesets))
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}
