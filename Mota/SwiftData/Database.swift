//
//  Database.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

protocol Database: Sendable {
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T]
    func save() async throws
    func delete<T: PersistentModel>(_ model: T) async
    func insert<T>(_ model: T) async where T: PersistentModel
    func fetchCount<T: PersistentModel>( fetchDescriptor: FetchDescriptor<T>) async throws -> Int
    func update<T: PersistentModel>(_ model: T, with changes: (inout T) -> Void) async throws
}

// TODO: Extend Database protocol to add necessary helper functions.
//extension Database {
//    func fetch<T: PersistentModel>(
//        where predicate: Predicate<T>?,
//        sortBy: [SortDescriptor<T>]
//    ) async throws -> [T] {
//        try await self.fetch(FetchDescriptor<T>(predicate: predicate, sortBy: sortBy))
//    }
//    
//    func fetch<T: PersistentModel>(
//        _ predicate: Predicate<T>,
//        sortBy: [SortDescriptor<T>] = []
//    ) async throws -> [T] {
//        try await self.fetch(where: predicate, sortBy: sortBy)
//    }
//    
//    func fetch<T: PersistentModel>(
//        _: T.Type,
//        predicate: Predicate<T>? = nil,
//        sortBy: [SortDescriptor<T>] = []
//    ) async throws -> [T] {
//        try await self.fetch(where: predicate, sortBy: sortBy)
//    }
//}
