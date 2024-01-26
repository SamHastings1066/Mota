//
//  AuthService.swift
//  Mota
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation
import FirebaseAuth

@Observable
final class AuthService {
    
    // TODO: The next two lines should be wrapped in conditional: if the current env is test then assign UserMock? and AuthserviceMock(). Now need to create user mock and authservice mock
    var currentUser: FirebaseAuth.User?
    private let auth = Auth.auth()
    static let shared = AuthService()
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.currentUser = user
            }
        }
    }
    
    private init() {
        //currentUser = auth.currentUser
        // see https://firebase.google.com/docs/auth/ios/manage-users for explanation of why setting a listener on the Auth object is better than using auth.currentUser directly.
        registerAuthStateHandler()
    }
    
    func signUpWithEmailPassword(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser = result.user
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        currentUser = result.user
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
    }
    
    func deleteAccount() async throws {
        try await currentUser?.delete()
        currentUser = nil
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    
}
