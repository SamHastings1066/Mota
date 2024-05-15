//
//  CollapsedRoundInfoView.swift
//  Mota
//
//  Created by sam hastings on 19/04/2024.
//

import SwiftUI

struct CollapsedRoundInfoView: View {
    @Binding var collapsedSuperset: SupersetNewView.CollapsedSuperset
    var body: some View {
        VStack(alignment: .center){
            VStack {
                Text("Rounds")
                    .font(.headline)

                    TextField("", value: $collapsedSuperset.numRounds, formatter: NumberFormatter())
                        .fixedSize()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
 
            }
            
            VStack {
                Text("Rest")
                    .font(.headline)

                    TextField("", value: $collapsedSuperset.rest, formatter: NumberFormatter())
                        .fixedSize()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

            }
        }
        .padding(.all, 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
        .fixedSize(horizontal: true, vertical: false)
    }
}

//#Preview {
//    CollapsedRoundInfoView()
//}
