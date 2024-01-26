//
//  HomeViewModel.swift
//  Mota
//
//  Created by sam hastings on 26/01/2024.
//

import Foundation

@Observable
class HomeViewModel {
    
    var authService: AuthenticationService
    
    var username = ""
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
}
