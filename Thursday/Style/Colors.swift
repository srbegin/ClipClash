//
//  Colors.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/19/21.
//

import SwiftUI

public extension Color {
    static let button: Self = Color("ButtonBackground", bundle: .main)
    static let buttonForeground: Self = Color("ButtonForeground", bundle: .main)
    
    static let error50  = Color("Error50", bundle: .main)
    static let error300 = Color("Error300", bundle: .main)
    static let error400 = Color("Error400", bundle: .main)
    static let error700 = Color("Error700", bundle: .main)
    static let error900 = Color("Error900", bundle: .main)

    static let success50  = Color("Success50", bundle: .main)
    static let success300 = Color("Success300", bundle: .main)
    static let success400 = Color("Success400", bundle: .main)
    static let success700 = Color("Success700", bundle: .main)
    static let success900 = Color("Success900", bundle: .main)

    static let warning50  = Color("Warning50", bundle: .main)
    static let warning300 = Color("Warning300", bundle: .main)
    static let warning400 = Color("Warning400", bundle: .main)
    static let warning700 = Color("Warning700", bundle: .main)
    static let warning900 = Color("Warning900", bundle: .main)

    static let primaryYellow200 = Color("PrimaryYellow200", bundle: .main)
    static let primaryYellow300 = Color("PrimaryYellow300", bundle: .main)
    static let primaryYellow400 = Color("PrimaryYellow400", bundle: .main)
    static let primaryYellow500 = Color("PrimaryYellow500", bundle: .main)

    static let primaryBlue200 = Color("PrimaryBlue200", bundle: .main)
    static let primaryBlue300 = Color("PrimaryBlue300", bundle: .main)
    static let primaryBlue400 = Color("PrimaryBlue400", bundle: .main)
    static let primaryBlue500 = Color("PrimaryBlue500", bundle: .main)

    static let neutral50  = Color("Neutral50", bundle: .main)
    static let neutral100 = Color("Neutral100", bundle: .main)
    static let neutral200 = Color("Neutral200", bundle: .main)
    static let neutral300 = Color("Neutral300", bundle: .main)
    static let neutral400 = Color("Neutral400", bundle: .main)
    static let neutral500 = Color("Neutral500", bundle: .main)
    static let neutral600 = Color("Neutral600", bundle: .main)
    static let neutral700 = Color("Neutral700", bundle: .main)
    static let neutral800 = Color("Neutral800", bundle: .main)
    static let neutral900 = Color("Neutral900", bundle: .main)
}

public enum Style {
    static var yellowBackground: some View {
        LinearGradient.linearGradient(
            stops: [
                .init(color: Color("Gradient-0", bundle: .main), location: 0),
                .init(color: Color("Gradient-1", bundle: .main), location: 0.69),
                .init(color: Color("Gradient-2", bundle: .main), location: 1),
                   ],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(Image(decorative: "BackgroundTexture", bundle: .main))
            .ignoresSafeArea()
    }
    

    enum Splash {
        static var background: some View {
            LinearGradient.linearGradient(
                stops: [
                    .init(color: Color("BackgroundGradient0", bundle: .main), location: 0.1331),
                    .init(color: Color("BackgroundGradient1", bundle: .main), location: 0.7402),
                    .init(color: Color("BackgroundGradient2", bundle: .main), location: 0.9686)
                ],
                startPoint: .top,
                endPoint: .bottomLeading
            )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Image(decorative: "DarkBackgroundTexture", bundle: .main).opacity(0.5))
                .ignoresSafeArea()
        }
    }
}

struct Style_Previews: PreviewProvider {
    static var previews: some View {
        Style.Splash.background
            //.frame(width: 100, height: 100, alignment: .center)
    }
}
