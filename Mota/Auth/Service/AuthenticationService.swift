//
//  AuthenticationService.swift
//  Mota
//
//  Created by sam hastings on 25/01/2024.
//

import Foundation

protocol AuthenticationService: Observable {
    var currentUser: AppUser? { get }
    func signUpWithEmailPassword(email: String, password: String) async throws
    func signInWithEmailPassword(email: String, password: String) async throws
    func signOut() throws
    func deleteAccount() async throws
    func resetPassword(email: String) async throws
}
