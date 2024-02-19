//
//  AddExerciseView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI

struct AddExerciseView: View {
    
    @State var exerciseList = ["Squat", "Bench press", "Deadlift"]
    

    
    var body: some View {

        
        NavigationSplitView {
            ExerciseList()
        } detail: {
            Text("Select an exercise")
        }
        
    }
    
}

struct ExerciseList: View {
    
    @State private var singleSelection: UUID?
    var body: some View {
        List(exercises, selection: $singleSelection) { exercise in
            NavigationLink {
                EditSetView()
            } label: {
                ExerciseRowView(exercise: exercise)
            }
            
            
        }
        .navigationTitle("Exercises")
    }
}

#Preview {
    AddExerciseView()
}


