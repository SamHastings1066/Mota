//
//  AddExerciseView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI

struct AddExerciseView: View {
    
    @State var exerciseList = ["Squat", "Bench press", "Deadlift"]
    @Binding var path: NavigationPath

    
    var body: some View {

        
        NavigationSplitView {
            ExerciseList()
        } detail: {
            Text("Select an exercise")
        }
        
    }
    
}

struct ExerciseList: View {
    var body: some View {
        List(exercises) { exercise in
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
    AddExerciseView(path: .constant(NavigationPath()))
}


