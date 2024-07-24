//
//  DeleteItemButton.swift
//  Mota
//
//  Created by sam hastings on 23/05/2024.
//

import SwiftUI

struct DeleteItemButton: View {
    @State private var showingAlert = false
    var deletionClosure: () -> Void
    var body: some View {
        Button {
            //
        } label: {
            Image(systemName: "trash")
        }
        .onTapGesture {
            hideKeyboard()
            //showingAlert = true
                        withAnimation {
                            deletionClosure()
                        }
        }
//        .alert(isPresented:$showingAlert) {
//            Alert(
//                title: Text("Are you sure you want to delete this item?"),
//                primaryButton: .destructive(Text("Delete")) {
//                    withAnimation {
//                        deletionClosure()
//                    }
//                },
//                secondaryButton: .cancel()
//            )
//        }
    }
}

#Preview {
    DeleteItemButton(){
        // Deletion closure
    }
}
