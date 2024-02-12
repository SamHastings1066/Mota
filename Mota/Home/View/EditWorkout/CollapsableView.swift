//
//  CollapsableView.swift
//  Mota
//
//  Created by sam hastings on 09/02/2024.
//

import SwiftUI

struct CollapsableView: View {
    @State private var isDisclosed = false
    
    var body: some View {
        VStack {
            Button("Expand") {
                withAnimation {
                    isDisclosed.toggle()
                }
            }
            .buttonStyle(.plain)
            
            
            VStack {
                GroupBox {
                    Text("Hi")
                }
                
                GroupBox {
                    Text("More details here")
                }
            }
            .frame(height: isDisclosed ? nil : 0, alignment: .top)
            .clipped()
            
            HStack {
                Text("Cancel")
                Spacer()
                Text("Book")
            }
        }
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .padding()
    }
}

#Preview {
    CollapsableView()
}
