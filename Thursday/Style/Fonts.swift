//
//  Fonts.swift
//  Thursday
//
//  Created by Peter Kovacs on 2/13/22.
//

import SwiftUI

extension Font {
    static let h1 = Font.custom(
        "AttenNew-ExtraBold",
        size: 42,
        relativeTo: .title
    ).leading(.loose)
    
    static let h2 = Font.custom(
        "AttenNew-ExtraBold",
        size: 35,
        relativeTo: .title
    ).leading(.loose)

    static let h3 = Font.custom(
        "AttenNew-ExtraBold",
        size: 26,
        relativeTo: .title
    ).leading(.loose)

    static let h4 = Font.custom(
        "AttenNew-ExtraBold",
        size: 22,
        relativeTo: .title
    ).leading(.loose)

    static let h5 = Font.custom(
        "AttenNew-ExtraBold",
        size: 20,
        relativeTo: .title
    ).leading(.loose)

    static let h6 = Font.custom(
        "AttenNew-Bold",
        size: 18,
        relativeTo: .title
    ).leading(.loose)
    
    static let body1 = Font.system(size: 16, weight: .regular, design: .default)
    static let body2 = Font.system(size: 14, weight: .regular, design: .default)
    static let body3 = Font.system(size: 11, weight: .regular, design: .default)
    static let bodyXL = Font.system(size: 20, weight: .light, design: .default)

    static let button1 = Font.custom("AttenNew-Bold", size: 16, relativeTo: .body)
    static let button2 = Font.custom("AttenNew-Bold", size: 14, relativeTo: .body)
    static let overline1 = Font.custom("AttenNew-Regular", size: 14, relativeTo: .body)
    static let overline2 = Font.custom("AttenNew-Regular", size: 11, relativeTo: .body)

    static let navigationTab = Font.custom("AttenNew-Regular", size: 11, relativeTo: .caption)
    
//    static let customBody = Font.custom("AttenNew-Regular", size: 17, relativeTo: .body)
//    static let customTitle = Font.custom("AttenNew-ExtraBold", size: 50, relativeTo: .title)
//    static let signUpButton = Font.custom("AttenNew-Bold", size: 16, relativeTo: .body)
}

struct Font_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("The quick brown fox jumps over the lazy dog")
                .font(.body)
                .previewDisplayName("body")

            Text("The quick brown fox jumps over the lazy dog")
                .font(.h1)
                .previewDisplayName("h1")

            Text("The quick brown fox jumps over the lazy dog")
                .font(.h2)
                .previewDisplayName("h2")

            Text("The quick brown fox jumps over the lazy dog")
                .font(.h3)
                .previewDisplayName("h3")

            Text("The quick brown fox jumps over the lazy dog")
                .font(.h4)
                .previewDisplayName("h4")

            Text("The quick brown fox jumps over the lazy dog")
                .font(.h5)
                .previewDisplayName("h5")

            Text("The quick brown fox jumps over the lazy dog")
                .font(.h6)
                .previewDisplayName("h6")
        }
        .previewLayout(.sizeThatFits)
    }
}
