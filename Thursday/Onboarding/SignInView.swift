//
//  SignInView.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/24/21.
//

import SwiftUI
import Foundation
import Combine


struct SignInView: View {
    
    var onLogin: () -> Void = {}
    
    enum Field {
        case email, password, username
    }
    @FocusState private var focus: Field?
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var userState: UserState
    
    @State var isLoading: Bool = false
    @State var user: SignInCreds = .init()
    
    struct SignInCreds: Codable, Equatable, Hashable {
//        var email: String = "testuser@test.com"
//        var password: String = "772290Th!"
        var email: String = ""
        var password: String = ""
    }
    
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    Color(.systemGray6).edgesIgnoringSafeArea(.all)
                    
                    VStack (spacing: 10){
                        EmailInputView(placeHolder: "Email", txt: $user.email)
                            .focused($focus, equals: .email)
                            .onSubmit {
                                Task { await self.signIn() }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))

                        PasswordInputView(placeHolder: "Password", txt: $user.password)
                            .focused($focus, equals: .password)
                            .onSubmit {
                                Task { await self.signIn() }
                            }
                            .padding().background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        
//                        SecureField("Password", text: $user.password, prompt: Text("Password"))
//                            .textContentType(.password)
//                            .textInputAutocapitalization(.never)
//                            .focused($focus, equals: .password)
//                            .onSubmit {
//                                Task { await self.signIn() }
//                            }
//                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
//                        
                        
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Button(action: {
                                Task {
                                    if focus == .email {
                                        focus = .password
                                    } else {
                                        focus = nil
                                    }
                                    await signIn()
                                }
                            }){ Text("Submit").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
                            }.frame(width:300).buttonStyle(YellowWideButton())
                                .padding()
                        }
                        
                        Spacer()
                    }
                    .background(Color(.systemGray6))
                    .padding()
                    .onChange(of: self.focus) {
                        focus = $0
                    }
                    .onChange(of: focus) {
                        self.focus = $0
                    }
                    
                }
            }
            .navigationBarTitle(Text("Sign In"))
            
            
        }
        
    }
    
    func signIn() async {
        guard user.email.isValidEmail else {
            focus = .email
            return
        }
        
        guard !user.password.isEmpty else {
            focus = .password
            return
        }

        isLoading = true
        Task {
            do {
                try await LoginManager().doLogin(email: user.email, password: user.password)

                isLoading = false
            } catch {
                print("Error in SignInView.signIn()")
                print(error)
                isLoading = false
            }
        }
    }
    
    func signOut() async {
        await LoginManager().doLogout()
    }
}

//struct EmailInputView: View {
//    var placeHolder: String = ""
//    @Binding var txt: String
//    
//    var body: some View {
//        TextField(placeHolder, text: $txt)
//            .keyboardType(.emailAddress)
//            .textInputAutocapitalization(.never)
//            .onReceive(Just(txt)) { newValue in
//                let validString = newValue.filter { "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._-+$!~&=#[]@".contains($0) }
//                if validString != newValue {
//                    self.txt = validString
//                }
//        }
//    }
//}
//
//struct PasswordInputView: View {
//    var placeHolder: String = ""
//    @Binding var txt: String
//    @Binding var feedback: [String]
//    
//    var body: some View {
//        SecureField("Password", text: $txt, prompt: Text("Password"))
//            .textContentType(.password)
//            .onReceive(Just(txt)) { newValue in
//                
//                let validString = newValue.filter { "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._-+$!~&=#[]@".contains($0) }
//                if validString != newValue {
//                    self.txt = validString
//                }
//                
//                if newValue.count < 8 {
//                    feedback[0] = "Password must be at least 8 characters"
//                    } else { feedback[0] = "" }
//                
//                if newValue.range(of: #"\d+"#, options: .regularExpression) == nil {
//                    feedback[1] = "Password must contain at least one digit"
//                } else { feedback[1] = "" }
//                
//                if newValue.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
//                    feedback[2] = "Password must contain at least one letter"
//                } else { feedback[2] = "" }
//        }
//    }
//}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
