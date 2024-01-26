//
//  LoginView.swift
//  Mota
//
//  Created by sam hastings on 19/01/2024.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var viewModel: LoginViewModel
    
    @FocusState private var focus: FocusableField?
    
    //@Environment(FirebaseAuthService.self) var authService
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(minHeight: 300, maxHeight: 400)
                    .scaledToFit()
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "at")
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            self.focus = .password
                        }
                        .accessibilityIdentifier("loginEmailTextField")
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 4)
                //EmailTextField(email: $viewModel.email, focusState: $focus)
                
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $viewModel.password)
                        .focused($focus, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            viewModel.signInWithEmailPassword()
                        }
                        .accessibilityIdentifier("loginPasswordSecureTextField")
                    
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)
                //                PasswordSecureField(password: $viewModel.password, label: "Password", nextFocus: .password, focusState: $focus) {
                //                                viewModel.signInWithEmailPassword()
                //                            }
                
                NavigationLink{
                    ResetPasswordView(viewModel: viewModel)
                        .navigationTitle("Reset password")
                } label: {
                        Text("Forgot password?")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color(UIColor.systemRed))
                            .accessibilityIdentifier("loginErrorMessageText")
                            .fixedSize(horizontal: false, vertical: true) // This ensures that the Text view can grow vertically.
                    }
                }
                
                LoginButton(viewModel: viewModel)
                //LoginButton(viewModel: viewModel, authService: authService)
                
                
                HStack {
                    Text("Don't have an account yet?")
                    Button {
                        viewModel.switchFlow()
                    } label: {
                        Text("Sign Up")
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

struct LoginButton: View {
    
    var viewModel: LoginViewModel
    
    //var authService: FirebaseAuthService
    
    var body: some View {
        Button(action: viewModel.signInWithEmailPassword) {
        //Button(action: authService.signInWithEmailPassword) {
            if viewModel.authenticationState != .authenticating {
                Text("Login")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("loginLoginButton")
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


#Preview {
    //Delete
    //@Environment(FirebaseAuthService.self) var authService
    //@State var viewModel = LoginViewModel(authService: authService)
    @State var viewModel = LoginViewModel()
    return LoginView(viewModel: $viewModel)
}
