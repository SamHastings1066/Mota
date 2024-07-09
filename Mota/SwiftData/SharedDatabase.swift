//
//  SharedDatabase.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

struct SharedDatabase {
    static let shared = SharedDatabase()
    
    //let schemas: [any PersistentModel.Type]
    let modelContainer: ModelContainer
    let database: any Database
    
    private init(
        //schemas: [any PersistentModel.Type] = .all,
        modelContainer: ModelContainer? = nil,
        database: (any Database)? = nil) {
            let schema = Schema([WorkoutNew.self])
            let config = ModelConfiguration(schema: schema)
            // TODO: remove forced unwrap 
            let container = try! ModelContainer(for: schema)
            let modelContainer = modelContainer ?? container
        self.modelContainer = modelContainer
        self.database = database ?? BackgroundDatabase(modelContainer: modelContainer)
    }
}
