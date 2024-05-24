//
//  ExpandedSinglesetNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI
import SwiftData

struct ExpandedSinglesetNewView: View {
    
    @Bindable var singleset: SinglesetNew
    
    var body: some View {
            HStack {

                ExerciseImageView(exercise: singleset.exercise)
                    .frame(width: 70, height: 70)
                Grid {
                    Text(singleset.exercise?.name ?? "")
                        .font(.headline)
                    GridRow {
                    //HStack {
                        VStack {
                            Text("Reps")

                            Text("\(singleset.reps)")
    //                        TextField("", value: $singleset.reps, formatter: NumberFormatter())
    //                            .fixedSize()
    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
    //                            .keyboardType(.numberPad)

                        }
                        VStack {
                            Text("kgs")

                            Text("\(singleset.weight)")
    //                        TextField("", value: $singleset.weight, formatter: NumberFormatter())
    //                            .fixedSize()
    //                            .textFieldStyle(RoundedBorderTextFieldStyle())
    //                            .keyboardType(.numberPad)

                        }
                    }
                }
                Spacer()


            }
            .padding([.vertical, .leading], 10)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let singleset = SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10)
        
        container.mainContext.insert(singleset)
        
        return ExpandedSinglesetNewView(singleset: singleset)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
