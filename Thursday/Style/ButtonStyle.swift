//
//  ButtonStyle.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/19/21.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.button)
        .foregroundColor(.buttonForeground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct YellowWideButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.primaryYellow300)
            .foregroundColor(.black)
            //.shadow(color: .black, radius: 10, x: 5, y: 5)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct ClearWideButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(.white))
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
                )
            //.shadow(color: .black, radius: 10, x: 5, y: 5)
            .cornerRadius(25)
    }
}
