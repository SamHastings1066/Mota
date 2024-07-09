//
//  Database.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

protocol Database: Sendable {
    func fetch(_ descriptor: FetchDescriptor<WorkoutNew>) async throws -> [WorkoutNew]
    func save() async throws
    func delete() async throws
    func insert(_ model: WorkoutNew) async
}

// TODO: Extend Database protocol to add necessary helper functions.
