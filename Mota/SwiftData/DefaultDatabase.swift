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
    
    func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] {
        assertionFailure("No Database set.")
        throw NotImplementedError.instance
    }
    
    func save() async throws {
        assertionFailure("No Database set.")
        throw NotImplementedError.instance
    }
    
    func delete() async {
        assertionFailure("No Database set.")
    }
    
    func insert(_ model: some PersistentModel) async {
        assertionFailure("No Database set.")
    }
}
