//
//  PasswordSecureField.swift
//  Mota
//
//  Created by sam hastings on 23/01/2024.
//

import SwiftUI

struct PasswordSecureField: View {
    @Binding var password: String
    var label: String
    var nextFocus: FocusableField?
    var focusState: FocusState<FocusableField?>.Binding
    var onSubmitAction: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "lock")
            SecureField(label, text: $password)
                .focused(focusState, equals: nextFocus)
                .submitLabel(nextFocus != nil ? .next : .go)
                .onSubmit(onSubmitAction)
        }
        .padding(.vertical, 6)
        .background(Divider(), alignment: .bottom)
        .padding(.bottom, 8)
    }
}

#Preview {
    @FocusState var focus: FocusableField?
    return PasswordSecureField(password: .constant(""), label: "Password", focusState: $focus) {
        //pass
    }
}
