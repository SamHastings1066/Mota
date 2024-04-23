//
//  RestNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI

struct RestNewView: View {
    
    @Binding var rest: Int
    @Binding var isEditable: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Rest")
                .font(.headline)
            if isEditable {
                TextField("", value: $rest, formatter: NumberFormatter())
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            } else {
                Text("\(rest)")
            }
        }
        .padding( 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

#Preview {
    RestNewView(rest: .constant(60), isEditable: .constant(false))
}
