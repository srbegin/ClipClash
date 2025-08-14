//
//  IndicatingTextField.swift
//  Thursday
//
//  Created by Peter Kovacs on 3/27/22.
//

import SwiftUI

// TODO: Need to integrate this into a larger focusState. Is is possible to pass it in?

struct IndicatingTextField: View {
    enum State {
        case error(LocalizedStringKey), valid
    }
    
    let title: LocalizedStringKey
    var text: Binding<String>
    let state: State?
    @FocusState var focusState: Bool
    
    var borderColor: Color {
        if focusState {
            return .primaryBlue400
        }
        
        switch state {
        case .error:
            return Color.error400
        case .valid:
            return Color.neutral900
        case .none:
            return Color.neutral400
        }
    }
    
    var foregroundColor: Color {
        switch state {
        case .error:
            return Color.error700
        case .valid:
            return Color.neutral900
        case .none:
            return Color.neutral900
        }

    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField(title, text: text)
                    .focused($focusState)
                    .foregroundColor(foregroundColor)
                    .font(.body1)

                switch state {
                case .error:
                    Image(systemName: "xmark")
                        .foregroundColor(.error700)
                case .valid:
                    Image(systemName: "checkmark")
                        .foregroundColor(.success400)
                case .none:
                    if !text.wrappedValue.isEmpty {
                        Image(systemName: "x.circle")
                            .foregroundColor(.neutral600)
                            .onTapGesture { text.wrappedValue = "" }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(borderColor)
            )
            
            if case let .error(value) = state {
                Text(value)
                    .foregroundColor(.error700)
                    .font(.body3)
            }
        }
    }
}

struct IndicatingTextField_Previews: PreviewProvider {
    static var string = "Some Text"
    static var previews: some View {
        Group {
            IndicatingTextField(
                title: "Empty",
                text: .constant(""),
                state: nil
            )

            IndicatingTextField(
                title: "Non Empty",
                text: .constant("Some Text"),
                state: nil
            )
            
            IndicatingTextField(
                title: "Non Empty",
                text: .constant("Some Text"),
                state: .error("Sorry, that username is taken! Try entering a new one.")
            )

            IndicatingTextField(
                title: "Non Empty",
                text: .constant("Some Text"),
                state: .valid
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
