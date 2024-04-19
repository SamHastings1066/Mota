//
//  SupersetNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI
import SwiftData

struct SupersetNewView: View {
    
    @Bindable var superset: SupersetNew
    @State private var isExpanded = false
    @State private var isEditable = false
    var orderedSupersets: [SupersetNew]
    var index: Int {
        if let index = orderedSupersets.firstIndex(where: { $0.id == superset.id }) {
            return index
        } else {
            return 0
        }
    }
    
    var body: some View {
        VStack {
            SupersetHeaderNewView(isExpanded: $isExpanded, isEditable: $isEditable, index: index)
            ForEach(superset.orderedRounds) { round in
                ExpandedRoundNewView(round: round)
                
            }
            
        }
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: SuperSet.self, configurations: config)
//        
//        let superset1 = SupersetNew(name: "Squats")
//            
//        
//        return SupersetNewView(superset: superset1)
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}
