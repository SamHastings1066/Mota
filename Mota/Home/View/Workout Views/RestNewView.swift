//
//  RestNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI

struct RestNewView: View {
    
    @Binding var rest: Int
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Rest")
                .font(.headline)
            Text("\(rest)")
        }
        .padding( 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

#Preview {
    RestNewView(rest: .constant(60))
}
