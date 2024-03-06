//
//  SinglesetInfoView.swift
//  Mota
//
//  Created by sam hastings on 06/03/2024.
//

import SwiftUI

struct SinglesetInfoView: View {
    let name: String
    let reps: Binding<String>
    let weight: Binding<String>
    let isEditable: Bool

    var body: some View {
        VStack(alignment: .center) {
            Text(name)
                .font(.headline)
            HStack {
                VStack {
                    Text("Reps")
                    if isEditable {
                        TextField("", text: reps)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text(reps.wrappedValue)
                    }
                }
                VStack {
                    Text("kgs")
                    if isEditable {
                        TextField("", text: weight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text(weight.wrappedValue)
                    }
                }
            }
        }
    }
}

#Preview {
    Group {
        SinglesetInfoView(name: "Squat", reps: .constant("10"), weight: .constant("5"), isEditable: true)
        SinglesetInfoView(name: "Squat", reps: .constant("10"), weight: .constant("5"), isEditable: false)
    }
}
