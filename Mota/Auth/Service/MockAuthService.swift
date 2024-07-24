//
//  MockAuthService.swift
//  Mota
//
//  Created by sam hastings on 26/01/2024.
//

#if DEBUG
import Foundation

enum MockError: Error {
    case wrongPassword
}
//1:44:26
@Observable
class MockAuthService: AuthenticationService {
    var loggedIn: Bool?
    
    var currentUser: AppUser?
    
    init() {
        self.loggedIn = false
    }
    
    func validateForm(email: String, password: String) throws {
        if !email.isValidEmail() {
            throw AuthError.invalidEmail
        } else if email != "sam@example.com" {
            throw AuthError.userNotFound
        }
        else if email != "sam@example.com" || password != "123456" {
            throw AuthError.wrongPassword
        }
        
    }
    
    func signUpWithEmailPassword(email: String, password: String) async throws {
        throw MockError.wrongPassword
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws {
        func signUp(email: String, password: String) throws -> String {
//            if email != "sam@example.com" || password != "123456" {
//                throw MockError.wrongPassword
//            }
            try validateForm(email: email, password: password)
//            if !email.isValidEmail() {
//                throw AuthError.invalidEmail
//            }
            
            return email
        }
        let userEmail = try signUp(email: email, password: password)
        currentUser = AppUser(uid: nil, email: userEmail)
        loggedIn = true
    }
    
    func signOut() throws {
        throw MockError.wrongPassword
    }
    
    func deleteAccount() async throws {
        throw MockError.wrongPassword
    }
    
    func resetPassword(email: String) async throws {
        throw MockError.wrongPassword
    }
    
    
}

#endif
