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

@Observable
class MockAuthService: AuthenticationService {
    var currentUser: AppUser?
    
    func signUpWithEmailPassword(email: String, password: String) async throws {
        throw MockError.wrongPassword
    }
    
    func signInWithEmailPassword(email: String, password: String) async throws {
        func signUp(email: String, password: String) throws -> String{
            if email != "sam@example.com" || password != "123456" {
                throw MockError.wrongPassword
            }
            return email
        }
        let userEmail = try signUp(email: email, password: password)
        currentUser = AppUser(uid: nil, email: userEmail)
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
