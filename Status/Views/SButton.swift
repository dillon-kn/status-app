//
//  SButton.swift
//  Status
//
//  Created by Dillon Nguyen on 7/11/24.
//

import SwiftUI

struct SButton: View {
    let title: String
    let background: Color
    let action: () -> Void // Take an action that is a function with no return value
    
    var body: some View {
        Button(action: {
            // Action
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }
}

//#Preview {
//    SButton()
//}
