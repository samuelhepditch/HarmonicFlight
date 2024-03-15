//
//  MusicalButton.swift
//  Harmonic Flight
//
//  Created by Sam Hepditch on 2024-03-14.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let buttonText: String
    
    init(action: @escaping () -> Void, buttonText: String) {
        self.action = action
        self.buttonText = buttonText
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(buttonText)
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.white, lineWidth: 2)
            )
        }
        .frame(width: 300)
    }
}

