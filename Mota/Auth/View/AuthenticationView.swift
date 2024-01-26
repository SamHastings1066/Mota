//
//  AuthenticationView.swift
//  Mota
//
//  Created by sam hastings on 21/01/2024.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State var viewModel = LoginViewModel()
//    @State var viewModel: LoginViewModel
//    @Environment(FirebaseAuthService.self) var authService
    
    //Delete this
//    init(viewModel: LoginViewModel) {
//        self.viewModel = LoginViewModel(authService: authService)
//    }
    
    var body: some View {
        switch viewModel.flow {
        case .login:
            LoginView(viewModel: $viewModel)
        case .signUp:
            SignupView(viewModel: $viewModel)
        }
    }
}

#Preview {
    AuthenticationView()
//    @Environment(FirebaseAuthService.self) var authService
//    return AuthenticationView(viewModel: LoginViewModel(authService: authService))
}
