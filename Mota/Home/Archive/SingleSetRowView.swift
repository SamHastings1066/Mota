//
//  SingleSetRowView.swift
//  Mota
//
//  Created by sam hastings on 09/02/2024.
//

import SwiftUI

//struct SingleSetRowView: View {
//    var singleSet: SingleSet
//    
//    var imageName: String? {
//        if !(singleSet.exercise?.imageURLs.isEmpty ?? false) {
//            return singleSet.exercise?.imageURLs[0]
//        } else {
//            return nil
//        }
//    }
//    
//    var body: some View {
//        HStack {
//            
//            // TODO: Add thumbnail image animating back and forth between the two images
//            SafeImageView(imageName: imageName, fullSizeImageURL: nil)
//                .frame(width: 70, height: 70)
//                //.padding(.trailing)
//            
//            VStack(alignment: .center) {
//                Text(singleSet.exercise?.name ?? "")
//                    .font(.headline)
//                HStack{
//                    VStack{
//                        Text("Reps")
//                        //Text("\(singleSet.reps.map{ "\($0)"} ?? "-")")
//                        Text("\(singleSet.reps)")
//                    }
//                    VStack {
//                        Text("kgs")
//                        //Text("\(singleSet.weight.map{ "\($0)"} ?? "-")")
//                        Text("\(singleSet.weight)")
//                    }
//                }
//                //Text("\(singleSet.reps.map{ "\($0)"} ?? "?") x \(singleSet.weight.map{ "\($0)"} ?? "?")")
//                
//                
//            }
//            Spacer()
//            
//            
//        }
//        .padding([.vertical, .leading], 10)
//        .background(Color(UIColor.systemGray5))
//        .cornerRadius(10)
//    }
//}

//struct SafeImageView: View {
//    let imageName: String?
//    var body: some View {
//        if let imageName = imageName {
//            if UIImage(named: imageName) != nil {
//                Image(imageName)
//                    .resizable()
//                    .scaledToFit()
//            } else {
//                Image(systemName: "figure.run.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//            }
//        } else {
//            Image(systemName: "figure.run.circle.fill")
//                .resizable()
//                .scaledToFit()
//        }
//    }
//}

//#Preview {
//    Group {
//        SingleSetRowView(singleSet: SingleSet(exercise: databaseExercises[0], weight: 0, reps: 8))
//        SingleSetRowView(singleSet: SingleSet(exercise: databaseExercises[7], weight: 60, reps: 10))
//    }
//}
