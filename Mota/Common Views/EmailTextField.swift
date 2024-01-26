//
//  EmailTextField.swift
//  Mota
//
//  Created by sam hastings on 23/01/2024.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    var focusState: FocusState<FocusableField?>.Binding
    var placeholder = "Email"

    var body: some View {
        HStack {
            Image(systemName: "at")
            TextField(placeholder, text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused(focusState, equals: .email)
                .submitLabel(.next)
        }
        .padding(.vertical, 6)
        .background(Divider(), alignment: .bottom)
        .padding(.bottom, 4)
    }
}

#Preview {
    @FocusState var focus: FocusableField?
    return EmailTextField(email: .constant("Email"), focusState: $focus)
}
