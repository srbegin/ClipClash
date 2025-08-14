//
//  RegistrationView.swift
//  Thursday
//
//  Created by Peter Kovacs on 3/27/22.
//

import SwiftUI
import UIKit

class RegistrationViewModel: ObservableObject {
    var onLogin: () -> Void = {}
}

struct RegistrationView: View {
    @ObservedObject var model: RegistrationViewModel
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordFeedback: [String] = ["Password must be at least 8 characters",
                                                     "Password must contain at least one digit",
                                                     "Password must contain at least one letter"]
    @State private var terms: Bool = false
    @State private var action: Int? = 0
    
    @State var newUser: User = AppConstants.defaultUser
        
    var body: some View {
        NavigationView {
            GeometryReader { _ in
                ZStack {
                    Color(.systemGray6).edgesIgnoringSafeArea(.all)
                    VStack(spacing: 10) {
                        
                        EmailInputView(placeHolder: "Choose a username", txt: $username)
                            .padding().background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        
                        EmailInputView(placeHolder: "Email Address", txt: $email)
                            .padding().background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        
                        PasswordSetView(placeHolder: "Password", txt: $password, feedback: $passwordFeedback)
                            .padding().background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        
                        VStack {
                            Text(passwordFeedback.joined(separator: "\n")).font(.caption)
                        }.frame(height: 75)
                        
                        VStack (alignment: .center){
                            NavigationLink(destination: RegistrationChooseProfilePhoto(newUser: newUser), tag: 1, selection: $action) {
                                EmptyView()
                            }
                            Button(action: {
                                Task {
                                    do {
                                        // Validate form fields
                                        self.newUser = try await LoginManager().doRegister(username: username, email: email, password: password)
                                        
                                        self.action = 1
                                    } catch ThursError.registrationError(let errorMessage) {
                                        self.errorHandling.handle(error: ThursError.registrationError(message: errorMessage), context: "RestrationView")
                                        print(errorMessage)
                                    }
                                }
                            }){
                                Text("Submit").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
                            }.frame(width:300).buttonStyle(YellowWideButton())
                            
                            
                            NavigationLink("Already have an account? Click here") {
                                SignInView()
                            }.padding()
                        }.padding()
                        
                        Spacer()
                    }
                }
                .navigationBarTitle(Text("Register!"))
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    self.hideKeyboard()
                }
            }
            
        }
//        .background(Color.white)
//        .navigationBarHidden(true)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#endif
