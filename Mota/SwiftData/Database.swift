//
//  Database.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

protocol Database: Sendable {
    func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel
    func save() async throws
    func delete() async throws
    func insert<T>(_ model: T) async where T: PersistentModel
    func fetchCount<T: PersistentModel>( fetchDescriptor: FetchDescriptor<T>) async throws -> Int
}

// TODO: Extend Database protocol to add necessary helper functions.
