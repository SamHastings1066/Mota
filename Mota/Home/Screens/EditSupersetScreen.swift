//
//  EditSupersetScreen.swift
//  Mota
//
//  Created by sam hastings on 15/05/2024.
//

import SwiftUI
import SwiftData

struct EditSupersetScreen: View {
    var superset: SupersetNew
    var body: some View {
        //TODO: Create edit superset form
        
        Text("EditSupersetScreen")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let superset = SupersetNew()
        
        container.mainContext.insert(superset)
        
        return NavigationStack {
            EditSupersetScreen(superset: superset)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
