//
//  SingleSetRowView.swift
//  Mota
//
//  Created by sam hastings on 09/02/2024.
//

import SwiftUI

struct SingleSetRowView: View {
    var singleSet: SingleSet
    
    var imageName: String? {
        if let databaseExercise = singleSet.exercise as? DatabaseExercise, !databaseExercise.imageURLs.isEmpty {
            return databaseExercise.imageURLs[0]
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack {
            
            // TODO: Add thumbnail image animating back and forth between the two images
            SafeImage(imageName: imageName)
                .frame(width: 70, height: 70)
                //.padding(.trailing)
            
            VStack(alignment: .center) {
                Text(singleSet.exercise.name)
                    .font(.headline)
                HStack{
                    VStack{
                        Text("Reps")
                        Text("\(singleSet.reps.map{ "\($0)"} ?? "-")")
                    }
                    VStack {
                        Text("kgs")
                        Text("\(singleSet.weight.map{ "\($0)"} ?? "-")")
                    }
                }
                //Text("\(singleSet.reps.map{ "\($0)"} ?? "?") x \(singleSet.weight.map{ "\($0)"} ?? "?")")
                
                
            }
            Spacer()
            
            
        }
        .padding([.vertical, .leading], 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

struct SafeImage: View {
    let imageName: String?
    var body: some View {
        if let imageName = imageName {
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
            } else {
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
            }
        } else {
            Image(systemName: "figure.run.circle.fill")
                .resizable()
        }
    }
}

#Preview {
    Group {
        SingleSetRowView(singleSet: SingleSet(exercise: exercises[0], reps: 8))
        SingleSetRowView(singleSet: SingleSet(exercise: UserDefinedExercise(name: "Squats"), weight: 60, reps: 10))
    }
}
