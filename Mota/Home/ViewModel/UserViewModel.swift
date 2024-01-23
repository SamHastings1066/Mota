//
//  HomeViewModel.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import Foundation

@Observable
class UserViewModel {
    
    var errorMessage = ""
    
    func signOut() {
            do {
                try AuthService.shared.signOut()
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
 
    }

    
}
