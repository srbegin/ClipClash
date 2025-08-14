//
//  ContentView.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/19/21.
//

import SwiftUI
import SwiftUINavigation
import CasePaths

enum AppState {
    case initial
    case loggedOut(LoggedOutViewModel)
    case loggedIn(LoggedInViewModel)
}

//class LoggedOutViewModel: ObservableObject {
//}

class LoggedInViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home
//    @Published var user: User
    
//    init(user: User) {
//        self.user = user
//    }
    
    enum Tab {
        case home
        case videos
        case settings
        case search
    }
}

struct ContentView: View {
    
    @EnvironmentObject var userState: UserState
    @State var showModal =  false
    @State var isAuthenticated = ThursdayApp.IsAuthenticated()
    
    var body: some View {
        Group {
            isAuthenticated ?
            AnyView(ThursTabView()
                .task {
                    userState.userModel = await LoginManager().getUserById(id: String(UserDefaults.standard.integer(forKey: "userId")))
                }
              )
            
            : AnyView(RegistrationView(model: RegistrationViewModel()))
        }
        .onReceive(ThursdayApp.Authenticated, perform: {
                     isAuthenticated = $0
        })
        
    }
    
}

extension ContentView {
  

  
}


class AppModel: ObservableObject {
    @Published var state: AppState = .initial
    
    init() {
    }
    
    func onAppear() {
        Task { @MainActor in
            
            // • Check to see if we have any stored credentials.
            // • Verify that the stored credentials still work?
            try! await Task.sleep(nanoseconds: 750 * NSEC_PER_MSEC )
            
            // -> Otherwise, we're in the logged out state.
            let viewModel = LoggedOutViewModel()
            viewModel.onLogin = onLogin
            state = .loggedOut(viewModel)
        }
    }
    
    private func onLogin() {
        // Transition the app to the logged in state.
        
    }
}

struct InitialView: View {
    @ObservedObject var model: AppModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(decorative: "AppLogo", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220, alignment: .center)
                Spacer()
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .background(
            Style.yellowBackground
                .ignoresSafeArea(.all, edges: .all)
        )
        .onAppear {
            model.onAppear()
        }
    }
}


struct AppView: View {
    @ObservedObject var model: AppModel
    
    var body: some View {
        Switch($model.state) {
            CaseLet(/AppState.initial) { _ in
                InitialView(model: model)
            }
            
            CaseLet(/AppState.loggedOut) { model in
                LoggedOutView(model: model.wrappedValue)
            }
            
            CaseLet(/AppState.loggedIn) { a in
                VStack {
                    Text("Logged In")
                }
//                .background(RadialGradient.backgroundYellowGradient)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    struct Wrapper: View {
        @StateObject var model = AppModel()
        
        var body: some View {
            AppView(model: model)
        }
    }
    static var previews: some View {
        NavigationView {
            Wrapper()
        }
    }
}
