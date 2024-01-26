//
//  FirebaseAuthService.swift
//  Mota
//
//  Created by sam hastings on 25/01/2024.
//

import Foundation
import FirebaseAuth

extension AppUser {
    init(firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
    }
}

@Observable class FirebaseAuthService: AuthenticationService {
    
    var currentUser: AppUser?
    var firebaseUser: FirebaseAuth.User?
    private let auth = Auth.auth()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = auth.addStateDidChangeListener { auth, user in
                self.firebaseUser = user
                if self.firebaseUser != nil {
                    self.currentUser = AppUser(firebaseUser: self.firebaseUser!)
                }
            }
        }
    }
    
    init() {
        registerAuthStateHandler()
    }
    
    func signUpWithEmailPassword(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser = AppUser(firebaseUser: result.user)
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws {
        print("WE GOT HERE")
        let result = try await auth.signIn(withEmail: email, password: password)
        currentUser = AppUser(firebaseUser: result.user)
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
    }
    
    func deleteAccount() async throws {
        try await firebaseUser?.delete()
        currentUser = nil
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    
}
