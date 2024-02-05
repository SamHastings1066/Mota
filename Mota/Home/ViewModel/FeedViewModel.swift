//
//  FeedViewModel.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import Foundation

@Observable
class FeedViewModel {
    
    var authService: AuthenticationService
    
    var username = ""
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
}
