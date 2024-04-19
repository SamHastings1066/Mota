//
//  SupersetHeaderNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI

struct SupersetHeaderNewView: View {
    @Binding var isExpanded: Bool
    @Binding var isEditable: Bool
    var index: Int
    var body: some View {
        Grid {
            GridRow {
                Text("Set \(index + 1)")
                Spacer()
                ChevronButtonNew(isChevronTapped: isExpanded) {isExpanded.toggle()}
                Spacer()
                EditButtonBespokeNew(isEditable: isEditable) {isEditable.toggle()}
            }
        }
    }
}

struct ChevronButtonNew: View {
    var isChevronTapped: Bool
    var buttonAction: () -> Void
    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: isChevronTapped ? "chevron.up" : "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
        }
        .onTapGesture {
            hideKeyboard()
                buttonAction()
        }
    }
}

struct EditButtonBespokeNew: View {
    var isEditable: Bool
    var buttonAction: () -> Void
    var body: some View {
        Button(action: {
            
        }) {
            Text( isEditable ? "Done" : "Edit")
        }
        .onTapGesture {
            hideKeyboard()
            withAnimation{
                buttonAction()
            }
        }
    }
}

#Preview {
    SupersetHeaderNewView(isExpanded: .constant(false), isEditable: .constant(false), index: 1)
}
