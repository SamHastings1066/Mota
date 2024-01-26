//
//  HomeViewModel.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

// TODO: pass the auth through to next views so that I can desiplay the user name and sign the user out.

import Foundation

@Observable
class UserViewModel {
    
    var errorMessage = ""
    //var username = AuthService.shared.currentUser?.displayName
    var username: String? {
        authService.currentUser?.email
    }
    var authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    func signOut() {
            do {
                //try AuthService.shared.signOut()
                try authService.signOut()
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
    }
    
    func deleteAccount() async -> Bool {
        do {
            //try await AuthService.shared.deleteAccount()
            try await authService.deleteAccount()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

}
