//
//  EditableSingleSetRowView.swift
//  Mota
//
//  Created by sam hastings on 18/02/2024.
//


import SwiftUI

struct EditableSingleSetRowView: View {
    @Binding var exercise: DatabaseExercise?
    @Binding var weight: Int
    @Binding var reps: Int
    
    var isEditable = true
    
    @State var isAddExercisePresented = false
    @State var selectedExercise: DatabaseExercise?
    

    var imageNames: [String?] {
        if !(exercise?.imageURLs.isEmpty ?? false) {
            return [exercise?.imageURLs[0], exercise?.imageURLs[1]]
        } else {
            return [nil,nil]
        }
    }
    
    private var weightString: Binding<String> {
        Binding<String>(
            get: {
                    return String(weight)
            },
            set: {
                    weight = Int($0) ?? 0
            }
        )
    }
    
    private var repsString: Binding<String> {
        Binding<String>(
            get: {
                    return String(reps)
            },
            set: {
                    reps = Int($0) ?? 0
            }
        )
    }
    
    var body: some View {
        HStack {
            exerciseAnimationView(imageNames: imageNames, fullSizeImageURLs: [nil,nil])
                .frame(width: 70, height: 70)
            SinglesetInfoView(name: exercise?.name ?? "", reps: repsString, weight: weightString, isEditable: isEditable)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .padding([.vertical, .leading], 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

//#Preview {
//    Group {
//        EditableSingleSetRowView(exercise: .constant(databaseExercises[0]), weight: .constant(0), reps: .constant(8))
//        EditableSingleSetRowView(exercise: .constant(databaseExercises[1]), weight: .constant(60), reps: .constant(10), isEditable: false)
//    }
//}
