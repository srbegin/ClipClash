//
//  LoggedOutView.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/24/21.
//

import SwiftUI
import SwiftUINavigation
import CasePaths

class LoggedOutViewModel: ObservableObject {
    enum Route {
        case signIn(SignInView)
        case register(RegistrationViewModel)
    }
        
    @Published var route: Route?
    
    var onLogin: () -> Void = {}
    
    func navigateSignIn(_ isActive: Bool) -> Void {
        if isActive {
            var model = SignInView()
            model.onLogin = { [weak self] in
                self?.route = nil
                self?.onLogin()
            }
            self.route = .signIn(model)
        } else {
            self.route = nil
        }
    }
    
    func navigateRegister(_ isActive: Bool) -> Void {
        if isActive {
            let model = RegistrationViewModel()
            model.onLogin = { [weak self] in
                self?.route = nil
                self?.onLogin()
            }
            self.route = .register(model)
        } else {
            self.route = nil
        }
    }

}

/// Initial Logged Out View with Logo, Register, Sign In buttons.
struct LoggedOutView: View {
    @ObservedObject var model: LoggedOutViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image(decorative: "LogoStacked", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 209, height: 170, alignment: .center)
                Spacer()
                Spacer()
            }

            VStack {
                Spacer()
                
                NavigationLink(unwrapping: $model.route, case: /LoggedOutViewModel.Route.register) {
                    RegistrationView(model: $0.wrappedValue)
                } onNavigate: { isActive in
                    model.navigateRegister(isActive)
                } label: {
                    Text("Register")
                }
                .buttonStyle(AppButtonStyle())
                
                NavigationLink(unwrapping: $model.route, case: /LoggedOutViewModel.Route.signIn) {_ in 
                    SignInView()
                } onNavigate: { isActive in
                    model.navigateSignIn(isActive)
                } label: {
                    Text("Sign In")
                }
                .buttonStyle(AppButtonStyle())
            }
        }
        .padding()
        .navigationBarHidden(true)
        .background(
            Style.yellowBackground
        )
    }
}

struct SplashView: View {
    @Namespace var namespace
    @State var logoAnimation = true
    @State var signInAnimation = true
    
    var splash0: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(decorative: "LogoMark", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 65.46, height: 105.46, alignment: .center)
                .matchedGeometryEffect(id: "logo", in: namespace)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("thursday")
                .font(.title)
                .fixedSize()
                .matchedGeometryEffect(id: "type", in: namespace)
            Spacer()
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .vertical)
        .background(Style.yellowBackground)
    }
    
    var splash1: some View {
        VStack(alignment: .leading) {
            Text("Today\nthe choice\nis yours.")
                .font(.title)
                .fixedSize()
                .matchedGeometryEffect(id: "type", in: namespace)
            Spacer()
            Image(decorative: "LogoMark", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 49.48, height: 80, alignment: .leading)
                .matchedGeometryEffect(id: "logo", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 34)
        .padding(.vertical, 50)
        .ignoresSafeArea(.all, edges: .vertical)
        .background(Style.yellowBackground)
    }
    
    var body: some View {
        Group {
            if !signInAnimation {
                SignUpView()
                    .transition(.move(edge: .bottom))
            } else if !logoAnimation {
                splash1
            } else {
                splash0
            }
        }
        .background(
            signInAnimation ? Style.yellowBackground : nil
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).delay(1.5)) {
                logoAnimation.toggle()
            }
            withAnimation(.easeInOut(duration: 0.3).delay(4.5)) {
                signInAnimation.toggle()
            }
        }
    }
}


struct SignUpView: View {
    @StateObject var model = LoggedOutViewModel()

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text("Sign up\nfor Thursday")
                    .font(.title)
                    .padding(.bottom, 30)
                
                Button {
                    model.navigateRegister(true)
                } label: {
                    Text("Sign up free")
                }
                .buttonStyle(.roundedBordered)
                
                Button {
                    // ...
                } label: {
                    Label("Continue with Apple", image: "apple-logo")
                }
                
                Button {
                    // ...
                } label: {
                    Label("Continue with Google", image: "google-logo")
                }
                
                Button {
                    // ...
                } label: {
                    Label("Continue with Twitter", image: "twitter-logo")
                }
                
                Button {
                    
                } label: {
                    Label("Continue with Facebook", image: "facebook-logo")
                }
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 34)
            .labelStyle(.outline)

            HStack {
                Text("Already have an account?")
                Button {
                    model.navigateSignIn(true)
                } label: {
                    Text("Log in")
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            .background(Color("LoginBackground", bundle: .main))
            .font(.body)
        }
        .fullScreenCover(unwrapping: $model.route, case: /LoggedOutViewModel.Route.register) { registrationModel in
            RegistrationView(model: registrationModel.wrappedValue)
        }
        .fullScreenCover(unwrapping: $model.route, case: /LoggedOutViewModel.Route.signIn) { signInModel in
            SignInView()
        }
    }
}

struct LoggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SplashView()
        }
        
        SplashView().splash0
        SplashView().splash1

        SignUpView()
    }
}
