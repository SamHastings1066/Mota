//
//  AuthServiceKey.swift
//  Mota
//
//  Created by sam hastings on 25/07/2024.
//

import Foundation
import SwiftUI

private struct AuthServiceKey: EnvironmentKey {
    static var defaultValue: any AuthenticationService {
        FirebaseAuthService()
    }
}

extension EnvironmentValues {
    var authService: any AuthenticationService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}

extension Scene {
    func authService(_ authService: any AuthenticationService) -> some Scene {
        self.environment(\.authService, authService)
    }
}
