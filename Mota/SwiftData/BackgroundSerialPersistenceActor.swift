//
//  BackgroundSerialPersistenceActor.swift
//  Mota
//
//  Created by sam hastings on 11/06/2024.
//

import Foundation
import SwiftData

@ModelActor
public actor BackgroundSerialPersistenceActor {

    public func fetchData<T: PersistentModel>(
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) async throws -> [T] {
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        let list: [T] = try modelContext.fetch(fetchDescriptor)
        return list
    }
    
    func fetchWorkout(
        predicate: Predicate<WorkoutTemplate>? = nil,
        sortBy: [SortDescriptor<WorkoutTemplate>] = []
    ) async throws -> [WorkoutTemplate] {
        let fetchDescriptor = FetchDescriptor<WorkoutTemplate>(predicate: predicate, sortBy: sortBy)
        let list: [WorkoutTemplate] = try modelContext.fetch(fetchDescriptor)
        return list
    }

    // Add other CRUD methods as needed
}


/// ```swift
///  // It is important that this actor works as a mutex,
///  // so you must have one instance of the Actor for one container
//   // for it to work correctly.
///  let actor = BackgroundSerialPersistenceActor(container: modelContainer)
///
///  Task {
///      let data: [MyModel] = try? await actor.fetchData()
///  }
///  ```
//public actor BackgroundSerialPersistenceActor: ModelActor {
//
//    public let modelContainer: ModelContainer
//    public let modelExecutor: any ModelExecutor
//    private var context: ModelContext { modelExecutor.modelContext }
//
//    public init(container: ModelContainer) {
//        self.modelContainer = container
//        let context = ModelContext(modelContainer)
//        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
//    }
//    
//    func fetchWorkout(by id: UUID) throws -> WorkoutTemplate? {
//        let fetchDescriptor = FetchDescriptor<WorkoutNew>(predicate: #Predicate { $0.id == id })
//        return try context.fetch(fetchDescriptor).first
//    }
//
//    public func fetchData<T: PersistentModel>(
//        predicate: Predicate<T>? = nil,
//        sortBy: [SortDescriptor<T>] = []
//    ) throws -> [T] {
//        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
//        let list: [T] = try context.fetch(fetchDescriptor)
//        return list
//    }
//
//    public func fetchCount<T: PersistentModel>(
//        predicate: Predicate<T>? = nil,
//        sortBy: [SortDescriptor<T>] = []
//    ) throws -> Int {
//        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
//        let count = try context.fetchCount(fetchDescriptor)
//        return count
//    }
//
//    public func insert<T: PersistentModel>(data: T) {
//        let context = data.modelContext ?? context
//        context.insert(data)
//    }
//
//    public func save() throws {
//        try context.save()
//    }
//
//    public func remove<T: PersistentModel>(predicate: Predicate<T>? = nil) throws {
//        try context.delete(model: T.self, where: predicate)
//    }
//
//    public func saveAndInsertIfNeeded<T: PersistentModel>(
//        data: T,
//        predicate: Predicate<T>
//    ) throws {
//        let descriptor = FetchDescriptor<T>(predicate: predicate)
//        let context = data.modelContext ?? context
//        let savedCount = try context.fetchCount(descriptor)
//
//        if savedCount == 0 {
//            context.insert(data)
//        }
//        try context.save()
//    }
//}

