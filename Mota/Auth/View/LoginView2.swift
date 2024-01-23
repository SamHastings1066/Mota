//
//  LoginView2.swift
//  Mota
//
//  Created by sam hastings on 19/01/2024.
//

import SwiftUI

// TODO: Adapt the UI to match the Firebase UI.
// Extract the UI components to separate objects

struct LoginView2: View {
    @State var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Image("Login")
                .resizable()
                .scaledToFit()
            
            Text("Login")
              .font(.largeTitle)
              .fontWeight(.bold)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                FirebaseTextField(placeholder: "Email", text: $viewModel.email)
                FirebaseSecureField(placeholder: "Password", text: $viewModel.password)
                
                if !viewModel.errorMessage.isEmpty {
                  VStack {
                    Text(viewModel.errorMessage)
                      .foregroundColor(Color(UIColor.systemRed))
                      //.accessibilityIdentifier("errorMessageText")
                  }
                }
                LoginButton(viewModel: viewModel)
                
                HStack {
                  Text("Don't have an account yet?")
                  Button(action: { viewModel.switchFlow() }) {
                    Text("Sign up")
                      .fontWeight(.semibold)
                      .foregroundColor(.blue)
                      .accessibilityIdentifier("signupButton")
                  }
                }
                .padding([.top, .bottom], 50)
                
                
            }
            .listStyle(.plain)
            .padding()
            
        }
    }
    
   
    
}




#Preview {
    LoginView2()
}

struct LoginButton: View {
    
    var viewModel: LoginViewModel
    
    var body: some View {
        Button(action: viewModel.signInWithEmailPassword) {
            if viewModel.authenticationState != .authenticating {
                Text("Login")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("loginButton")
            }
            else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
        }
        .disabled(!viewModel.loginCredentialsAreValid)
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
    }
}
