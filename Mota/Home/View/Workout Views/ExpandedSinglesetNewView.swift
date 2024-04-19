//
//  ExpandedSinglesetNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI

struct ExpandedSinglesetNewView: View {
    
    @Bindable var singleset: SinglesetNew
    
    var imageName: String? {
        if !(singleset.exercise?.imageURLs.isEmpty ?? false) {
            return singleset.exercise?.imageURLs[0]
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack {
            
            SafeImageView(imageName: imageName, fullSizeImageURL: nil)
                .frame(width: 70, height: 70)
            
            Grid {
                Text(singleset.exercise?.name ?? "")
                    .font(.headline)
                GridRow {
                    VStack {
                        Text("Reps")
                        
                        Text("\(singleset.reps)")
                        
                    }
                    VStack {
                        Text("kgs")
                        
                        Text("\(singleset.weight)")
                        
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
    ExpandedSinglesetNewView(singleset: SinglesetNew(exercise: DatabaseExercise.sampleExercises[2], weight: 10, reps: 20))
}
