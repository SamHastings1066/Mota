//
//  SignupView.swift
//  Mota
//
//  Created by sam hastings on 21/01/2024.
//

import SwiftUI

//private enum FocusableField: Hashable {
//  case email
//  case password
//  case confirmPassword
//}

struct SignupView: View {
    
    @Binding var viewModel: LoginViewModel
    
    @FocusState private var focus: FocusableField?

    var body: some View {
        VStack {
          Image("SignUp")
            .resizable()
            .aspectRatio(contentMode: .fit)
            //.frame(minHeight: 300, maxHeight: 400)
            .scaledToFit()
          Text("Sign up")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityIdentifier("signUpTitle")

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
          }
          .padding(.vertical, 6)
          .background(Divider(), alignment: .bottom)
          .padding(.bottom, 4)

          HStack {
            Image(systemName: "lock")
            SecureField("Password", text: $viewModel.password)
              .focused($focus, equals: .password)
              .submitLabel(.next)
              .onSubmit {
                self.focus = .confirmPassword
              }
          }
          .padding(.vertical, 6)
          .background(Divider(), alignment: .bottom)
          .padding(.bottom, 8)

          HStack {
            Image(systemName: "lock")
            SecureField("Confirm password", text: $viewModel.confirmPassword)
              .focused($focus, equals: .confirmPassword)
              .submitLabel(.go)
              .onSubmit {
                  viewModel.signUpWithEmailPassword()
              }
          }
          .padding(.vertical, 6)
          .background(Divider(), alignment: .bottom)
          .padding(.bottom, 8)

          if !viewModel.errorMessage.isEmpty {
            VStack {
              Text(viewModel.errorMessage)
                .foregroundColor(Color(UIColor.systemRed))
            }
          }

            Button(action: viewModel.signUpWithEmailPassword) {
            if viewModel.authenticationState != .authenticating {
              Text("Sign up")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
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

          HStack {
            Text("Already have an account?")
            Button(action: { viewModel.switchFlow() }) {
              Text("Log in")
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            }
          }
          .padding([.top, .bottom], 50)

        }
        .listStyle(.plain)
        .padding()
    }
}

#Preview {
    //Delete
    //@Environment(FirebaseAuthService.self) var authService
    //@State var viewModel = LoginViewModel(authService: authService)
    @State var viewModel = LoginViewModel()
    return SignupView(viewModel: $viewModel)
}
