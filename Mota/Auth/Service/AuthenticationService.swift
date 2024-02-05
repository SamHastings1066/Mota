//
//  AuthenticationService.swift
//  Mota
//
//  Created by sam hastings on 25/01/2024.
//

import Foundation

enum AuthError: Error {
    case mismatchedPasswords
    case wrongPassword
    case invalidEmail
    case userNotFound
    
    var localizedDescription: String {
        switch self {
        case .mismatchedPasswords:
            "Passwords do not match."
        case .wrongPassword:
            "The password is incorrect"
        case .invalidEmail:
            "The email address is badly formatted."
        case .userNotFound:
            "There is no user record corresponding to this identifier. The user may have been deleted."
        }
    }
}

protocol AuthenticationService: Observable {
    var currentUser: AppUser? { get }
    func signUpWithEmailPassword(email: String, password: String) async throws
    func signInWithEmailPassword(email: String, password: String) async throws
    func signOut() throws
    func deleteAccount() async throws
    func resetPassword(email: String) async throws
}
