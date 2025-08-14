//
//  ThursdayApp.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/19/21.
//

import SwiftUI
import Combine
import AVKit

class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
//    ) -> Bool {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        let atten16 = UIFont(name: "Atten New Bold", size: 16)!
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = .black
        navBarAppearance.largeTitleTextAttributes = [.font: UIFont(name: "Atten New Bold", size: 26)!]
        navBarAppearance.titleTextAttributes = [.font: atten16]
        
        let barItemAppearance = UIBarButtonItem.appearance()
        barItemAppearance.setTitleTextAttributes([.font: atten16], for: .normal)

        return true
    }
    
}

@main
struct ThursdayApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    static let Authenticated = PassthroughSubject<Bool, Never>()
    
    @StateObject var viewRouter = ViewRouter(currentPage: AppConstants.defaultScreen, previousPage: AppConstants.defaultScreen, currentProfileView: AppConstants.defaultProfileView)
    @StateObject var userState = AppConstants.initialUserState
    @StateObject var cameraModel = CameraViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var model = AppModel()
    
    @State var showModal =  false
    
    
    var body: some Scene {
        
        WindowGroup {
            
//            OnboardingScreens()
//            NavigationView {
//                ChooseRegistrationButtonsView()
//            }
//            NavigationView {
//                AppView(model: model)
//                    .navigationBarHidden(true)
//            }
            
            ContentView()
                .environmentObject(userState)
                .environmentObject(viewRouter)
                .environmentObject(cameraModel)
                .withErrorHandling()
                
        }
        .onChange(of: scenePhase) { (phase) in
            switch phase {
            case .active: print("ScenePhase: active")
            case .background:
                print("ScenePhase: background")
                do
                {
                    try AVAudioSession.sharedInstance().setActive(false)

                }
                catch
                {
                    print(error)
                }
            case .inactive: print("ScenePhase: inactive")
                do
                {
                    try AVAudioSession.sharedInstance().setActive(false)

                }
                catch
                {
                    print(error)
                }
            @unknown default: print("ScenePhase: unexpected state")
            }
        }
    }
    
    static func IsAuthenticated() -> Bool {
            return UserDefaults.standard.string(forKey: "userToken") != nil
        }
}
