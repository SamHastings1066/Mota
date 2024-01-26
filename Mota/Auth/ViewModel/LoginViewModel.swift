//
//  LoginViewModel.swift
//  Mota
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

enum AuthError: Error {
    case mismatchedPasswords
}

@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    var emailForPasswordReset = ""
    var authenticationState: AuthenticationState = .unauthenticated
    var loginCredentialsAreValid : Bool {
        //!(email.isEmpty || password.isEmpty)
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
    }
    var flow: AuthenticationFlow = .login
    var errorMessage = ""
    
    var authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    
    func validateSignUpForm() throws {
        if password != confirmPassword {
            throw AuthError.mismatchedPasswords
        }
    }
    
    func signInWithEmailPassword() {
        authenticationState = .authenticating
        Task {
            do {
                //try await AuthService.shared.signInWithEmailPassword(email: email, password: password)
                try await authService.signInWithEmailPassword(email: email, password: password)
                //authenticationState = .authenticated
            } catch {
                print(error)
                errorMessage = error.localizedDescription
                authenticationState = .unauthenticated
            }
            
        }
    }
    
    func signUpWithEmailPassword() {
        authenticationState = .authenticating
        Task {
            do {
                try validateSignUpForm()
                //try await AuthService.shared.signUpWithEmailPassword(email: email, password: password)
                try await authService.signUpWithEmailPassword(email: email, password: password)
            }
            catch AuthError.mismatchedPasswords {
                print("Passwords do not match.")
                errorMessage = "Passwords do not match."
                authenticationState = .unauthenticated
            }
            catch {
                print(error)
                errorMessage = error.localizedDescription
                authenticationState = .unauthenticated
            }
        }
    }
    
    func resetPassword() async -> Bool {
        
            do {
                //try await AuthService.shared.resetPassword(email: emailForPasswordReset)
                try await authService.resetPassword(email: emailForPasswordReset)
                errorMessage = "A password reset link has been sent to the email provided."
                return true
            } catch {
                print(error.localizedDescription)
                errorMessage = error.localizedDescription
                return false
            }
        
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
}
