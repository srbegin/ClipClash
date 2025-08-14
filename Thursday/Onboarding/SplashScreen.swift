//
//  SplashScreen.swift
//  Thursday
//
//  Created by Peter Kovacs on 3/13/22.
//

import SwiftUI

// The initial splash view should look just like the LaunchScreen.
// It will then animate into the StartScreenView.

fileprivate let splashDuration = 0.75
fileprivate let splashDelay = 0.75
fileprivate let animation1Duration = 0.5
fileprivate let animation1Delay = splashDelay + splashDuration
fileprivate let animation2Duration = 0.5
fileprivate let animation2Delay = animation1Delay + animation1Duration
fileprivate let animation3Duration = 0.5
fileprivate let animation3Delay = animation2Delay + animation2Duration

struct SplashScreen: View {
    var namespace: Namespace.ID
    
    @ViewBuilder var logo: some View {
        VStack(spacing: 13.83) {
            Image(decorative: "LogoMark", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 91.6, height: 102.98, alignment: .center)
                .matchedGeometryEffect(id: "LogoMark", in: namespace)
            Image(decorative: "LogoType", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 204, height: 49.19, alignment: .center)
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            logo
                .foregroundColor(.primaryYellow300)
                .frame(width: 204, height: 166, alignment: .center)
                .alignmentGuide(.center as VerticalAlignment) { $0[.bottom] } // match LaunchScreen
        }
    }
}

struct OnboardingScreen: View {
    var logoNamespace: Namespace.ID
    @State var animate1 = false
    @State var animate2 = false
    @State var animate3 = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if animate1 {
                Text("Today")
                    .font(.h1)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            if animate2 {
                Text("the choice")
                    .font(.h1)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            if animate3 {
                Text("is yours.")
                    .font(.h1)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            Spacer()
            
            Color.clear
                .frame(maxWidth: .infinity)
            
            Image(decorative: "LogoMark", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 80, alignment: .center)
                .matchedGeometryEffect(id: "LogoMark", in: logoNamespace)
        }
        .padding(.horizontal, 34)
        .padding(.top, 108)
        .padding(.bottom, 89)
        .foregroundColor(.primaryYellow300)
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: animation1Duration).delay(animation1Delay)) { animate1 = true }
            withAnimation(.easeInOut(duration: animation2Duration).delay(animation2Delay)) { animate2 = true }
            withAnimation(.easeInOut(duration: animation3Duration).delay(animation3Delay)) { animate3 = true }
        }
    }
}

struct OnboardingScreens: View {
    @Namespace var logoNamespace
    @State var animate = false
    
    var body: some View {
        Group {
            if !animate {
                SplashScreen(namespace: logoNamespace)
            } else {
                OnboardingScreen(logoNamespace: logoNamespace)
            }
        }
        .background(Style.Splash.background)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: splashDuration).delay(splashDelay)) {
                animate = true
            }
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        VStack {
            OnboardingScreens()
        }
        VStack {
            SplashScreen(namespace: namespace)
                .background(Style.Splash.background)
        }
    }
}
