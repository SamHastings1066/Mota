//
//  ResetPasswordView.swift
//  Mota
//
//  Created by sam hastings on 23/01/2024.
//

import SwiftUI

struct ResetPasswordView: View {
    @Bindable var viewModel: LoginViewModel
    
    @FocusState private var focus: FocusableField?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            EmailTextField(email: $viewModel.emailForPasswordReset, focusState: $focus, placeholder: "Please enter your email")
            
            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
            
            Button {
                Task {
                    if await viewModel.resetPassword() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                
            } label: {
                Text("Reset password")
                    .bold()
                    .padding()
            }
        }
        .padding()
        .onAppear{
            viewModel.errorMessage = ""
        }
    }
}

#Preview {
    //Delete
    @Environment(FirebaseAuthService.self) var authService
    return ResetPasswordView(viewModel: LoginViewModel(authService: authService))
    //ResetPasswordView(viewModel: LoginViewModel())
}
