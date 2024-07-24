//
//  DefaultDatabase.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

struct DefaultDatabase: Database {
    
    struct NotImplementedError: Error {
        static let instance =  NotImplementedError()
    }
    
    static let instance = DefaultDatabase()
    
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T] {
        assertionFailure("No Database set.")
        throw NotImplementedError.instance
    }
    
    func save() async throws {
        assertionFailure("No Database set.")
        throw NotImplementedError.instance
    }
    
    func delete<T: PersistentModel>(_ model: T) async {
        assertionFailure("No Database set.")
    }
    
    func insert(_ model: some PersistentModel) async {
        assertionFailure("No Database set.")
    }
    
    func fetchCount<T: PersistentModel>( fetchDescriptor: FetchDescriptor<T>) async throws -> Int {
        assertionFailure("No Database set.")
        throw NotImplementedError.instance
    }
    
    func update<T: PersistentModel>(_ model: T, with changes: (inout T) -> Void) async throws {
        assertionFailure("No Database set.")
        throw NotImplementedError.instance
    }
}
