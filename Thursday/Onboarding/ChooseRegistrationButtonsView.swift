//
//  ChooseRegistrationButtonsView.swift
//  Thursday
//
//  Created by Peter Kovacs on 11/24/21.
//

import SwiftUI

struct RegistrationFooterView: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.neutral900)

                NavigationLink {
                    Text("Log in")
                } label: {
                    Text("Log in")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .font(.body2)
        .padding(.vertical, 20)
        .padding(.bottom, 20)
        .background(Color.neutral50)
        .padding(.top, 20)
    }
}

struct ChooseRegistrationButtonsView: View {
    
    var signUpFree: some View {
        NavigationLink {
            RegistrationView(model: RegistrationViewModel())
        } label: {
            Text("Sign up free")
        }
        .buttonStyle(.roundedBordered)
    }
    
    var appleButton: some View {
        Button {
            print("Apple")
        } label: {
            Label("Continue with Apple", systemImage: "applelogo")
        }
        .labelStyle(.outline)
    }
    
    var googleButton: some View {
        Button {
            print("Google")
        } label: {
            Label("Continue with Google", image: "google-logo")
        }
        .labelStyle(.outline)
    }
    
    var twitterButton: some View {
        Button {
            print("Twitter")
        } label: {
            Label("Continue with Twitter", image: "twitter-logo")
        }
        .labelStyle(.outline)
    }
    
    var facebookButton: some View {
        Button {
            print("Facebook")
        } label: {
            Label("Continue with Facebook", image: "facebook-logo")
        }
        .labelStyle(.outline)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(maxHeight: 110)
                .layoutPriority(1)

            VStack(alignment: .leading) {
                Text("Sign up for Thursday")
                    .font(.h1)
                    .padding(.bottom, 20)
                    .foregroundColor(.neutral900)
                
                VStack(spacing: 10) {
                    signUpFree
                    appleButton
                    googleButton
                    twitterButton
                    facebookButton
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                Text(
                    "By continuing, you agree to Thursday’s [Terms of Use](https://thursday.com/tos) and confirm that you have read the [Privacy Policy](https://thursday.com/privacy)."
                )
                .font(.body3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            }
            .padding()
            .padding(.horizontal, 14)

            RegistrationFooterView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

struct ChooseRegistrationButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChooseRegistrationButtonsView()
        }
        .previewInterfaceOrientation(.portrait)
    }
}

//class UserRegistrationViewModel: ObservableObject {
//    @Published var isLoading: Bool = false
//    @Published var focus: RegistrationView.Field? = .none
//    @Published var hasError: Set<RegistrationView.Field> = .init()
//    @Published var user: User = .init()
//
//    var onLogin: () -> Void = {}
//
//    struct User: Codable, Equatable, Hashable {
//        var username: String = ""
//        var firstName: String = ""
//        var lastName: String = ""
//        var email: String = ""
//        var password: String = ""
//    }
//
//    func submit() {
//        switch focus {
//        case .firstName:
//            focus = .lastName
//        case .lastName:
//            focus = .username
//        case .username:
//            focus = .email
//        case .email:
//            focus = .password
//        case .password:
//            focus = nil
//        case nil:
//            break
//        }
//    }
//
//    @MainActor func register() async {
//    }
//}
//
//extension UserRegistrationViewModel.User {
//    var isValid: Bool {
//        return !username.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !password.isEmpty && email.isValidEmail
//    }
//}
//
//struct RegistrationView: View {
//    enum Field {
//        case username, email, firstName, lastName, password
//    }
//    @FocusState private var focus: Field?
//    @StateObject var model: UserRegistrationViewModel = .init()
//
//    var body: some View {
//        VStack {
//            Group {
//            TextField("First Name", text: $model.user.firstName, prompt: Text("First Name"))
//                .onSubmit(model.submit)
//                .textInputAutocapitalization(.words)
//                .textContentType(.name)
//                .focused($focus, equals: .firstName)
//
//            TextField("Last Name", text: $model.user.lastName, prompt: Text("Last Name"))
//                .onSubmit(model.submit)
//                .textInputAutocapitalization(.words)
//                .textContentType(.name)
//                .focused($focus, equals: .lastName)
//
//            TextField("Username", text: $model.user.username, prompt: Text("Username"))
//                .onSubmit(model.submit)
//                .textInputAutocapitalization(.never)
//                .textContentType(.username)
//                .focused($focus, equals: .username)
//
//            TextField("Email", text: $model.user.email, prompt: Text("Email"))
//                .onSubmit(model.submit)
//                .textInputAutocapitalization(.never)
//                .textContentType(.emailAddress)
//                .focused($focus, equals: .email)
//
//            SecureField("Password", text: $model.user.password, prompt: Text("Password"))
//                .onSubmit(model.submit)
//                .textContentType(.password)
//                .textInputAutocapitalization(.never)
//                .focused($focus, equals: .password)
//
//            }
//            .frame(maxWidth: 320)
//
//            if model.isLoading {
//                HStack {
//                    Spacer()
//                    ProgressView()
//                    Spacer()
//                }
//            } else {
//                Button("Next") {
//                    Task {
//                        await model.register()
//                    }
//                }
//                .buttonStyle(RoundedBorderedButtonStyle())
//                .disabled(!model.user.isValid)
//            }
//
//            Spacer()
//        }
//        .textFieldStyle(.roundedBorder)
//        .padding()
//        .onChange(of: model.focus) {
//            focus = $0
//        }
//        .onChange(of: focus) {
//            model.focus = $0
//        }
//        .navigationTitle("Sign up for Thursday")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RegistrationView()
//                .font(.customBody)
//        }
//    }
//}
