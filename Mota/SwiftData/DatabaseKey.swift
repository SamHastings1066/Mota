//
//  DatabaseKey.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftUI

private struct DatabaseKey: EnvironmentKey {
    static var defaultValue: any Database {
        DefaultDatabase.instance
    }
}

extension EnvironmentValues {
    var database: any Database {
        get { self[DatabaseKey.self] }
        set { self[DatabaseKey.self] = newValue }
    }
}

extension Scene {
    func database(_ database: any Database) -> some Scene {
        self.environment(\.database, database)
    }
}
