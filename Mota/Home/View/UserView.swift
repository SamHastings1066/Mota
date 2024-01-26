//
//  UserView.swift
//  Mota
//
//  Created by sam hastings on 20/01/2024.
//

import SwiftUI

struct UserView: View {
    
    var viewModel: UserViewModel
    var username = AuthService.shared.currentUser?.email
    @State var presentingConfirmationDialog = false
    
    
    private func deleteAccount() {
      Task {
        if await viewModel.deleteAccount() == true {
          
        }
      }
    }
    
    var body: some View {
      Form {
        Section {
          VStack {
            HStack {
              Spacer()
              Image(systemName: "person.fill")
                .resizable()
                .frame(width: 100 , height: 100)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .clipped()
                .padding(4)
                .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
              Spacer()
            }
            Button(action: {}) {
              Text("edit")
            }
          }
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
        Section("Email") {
          Text(username ?? "")
        }
        Section {
            Button(role: .cancel, action: viewModel.signOut) {
            HStack {
              Spacer()
              Text("Sign out")
              Spacer()
            }
          }
        }
        Section {
          Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
            HStack {
              Spacer()
              Text("Delete Account")
              Spacer()
            }
          }
        }
      }
      .navigationTitle("Profile")
      .navigationBarTitleDisplayMode(.inline)
      //.analyticsScreen(name: "\(Self.self)")
      .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                          isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
        Button("Delete Account", role: .destructive, action: deleteAccount)
        Button("Cancel", role: .cancel, action: { })
      }
    }
}

#Preview {
    UserView(viewModel: UserViewModel())
}
