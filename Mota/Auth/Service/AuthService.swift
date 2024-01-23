//
//  AuthService.swift
//  Mota
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation
import FirebaseAuth

final class AuthService {
    
    private let auth = Auth.auth()
    
    let shared = AuthService()
    
    private init() {
        
    }

    func signUpWithEmailPassword(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
    }
    
    
}
