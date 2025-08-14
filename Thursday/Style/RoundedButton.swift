//
//  RoundedButton.swift
//  Thursday
//
//  Created by Peter Kovacs on 2/15/22.
//

import SwiftUI

public extension LabelStyle where Self == OutlineLabelStyle {
    static var outline: OutlineLabelStyle { OutlineLabelStyle() }
}

public extension ButtonStyle where Self == RoundedBorderedButtonStyle {
    static var roundedBordered: RoundedBorderedButtonStyle { RoundedBorderedButtonStyle() }
}

public struct OutlineLabelStyle: LabelStyle {
    @Environment(\.isEnabled) var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            Spacer(minLength: 24)
            configuration.title
            Spacer()
        }
        .overlay(
            HStack {
                // TODO: we want to set renderingMode on the icon when not isEnabled so that we can color it with the disabled color.
                configuration.icon
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor( isEnabled ? .neutral900 : .neutral400 )
                Spacer()
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: 100))
        .padding(.vertical, 14.35)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.neutral300, lineWidth: 1)
        )
        .foregroundColor(
            isEnabled ? .neutral900 : .neutral400
        )
        .font(.button1)
        .frame(maxWidth: 320)
    }
}

public struct RoundedBorderedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    var backgroundColor: Color
    var foregroundColor: Color = .primary
    
    public init(
        backgroundColor: Color = .primaryYellow300,
        foregroundColor: Color = .neutral900
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.button1)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 14.35)
            .contentShape(RoundedRectangle(cornerRadius: 100))
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .foregroundColor(
                        isEnabled ? backgroundColor : .neutral100
                    )
            )
            .frame(maxWidth: 320)
            .opacity(configuration.isPressed ? 0.3 : 1.0)
            .foregroundColor(
                isEnabled ? foregroundColor : .neutral400
            )
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button {
            } label: {
                Text("Sign up free")
            }
            .buttonStyle(.roundedBordered)
            
            Button {
            } label: {
                Text("Sign up free")
            }
            .buttonStyle(.roundedBordered)
            .disabled(true)
            
            Button {
                
            } label: {
                Label("Continue with Apple", systemImage: "applelogo")
            }
            .labelStyle(.outline)
            .disabled(true)
            
            Button {
                
            } label: {
                Label("Continue with Google", image: "google-logo")
            }
            .labelStyle(.outline)
            .disabled(true)
           
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

