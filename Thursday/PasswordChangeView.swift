//
//  PasswordChangeView.swift
//  Thursday
//
//  Created by Scott Begin on 12/15/22.
//

import SwiftUI

struct PasswordChangeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var currentPassword: String = ""
    @State private var newPassword1: String = ""
    @State private var newPassword2: String = ""
    @State private var response: String?
    
    var body: some View {
        
        VStack {
            
            ZStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Cancel")
                    }
                    .padding(.trailing)
                    .padding(.top)
                }
                HStack {
                    Spacer()
                    Text("Change Password").font(Font.h5).foregroundColor(.black).padding(.top)
                    Spacer()
                }
            }
            .padding(.bottom)
            
            Form {
                Section {
                    SecureField("Current password:", text: $currentPassword)
                    SecureField("New password:", text: $newPassword1)
                    SecureField("Retype new password:", text: $newPassword2)
                    
                }
                
                Section {
                    VStack (alignment: .center){
                        Button(action: {
                            Task {
                                do {
                                    
                                    response = try await Network().changePassword(newPassword1: newPassword1, newPassword2: newPassword2, oldPassword: currentPassword)
                                    
                                } catch ThursError.registrationError(let errorMessage) {
                                    self.errorHandling.handle(error: ThursError.registrationError(message: errorMessage), context: "RestrationView")
                                    print(errorMessage)
                                }
                            }
                        }){
                            Text("Submit").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
                        }.frame(width:300).buttonStyle(YellowWideButton())
                    }
                }
            }
        }
        .alert(item: $response) {response in
            Alert(title: Text("Change Password"), message: Text(response), dismissButton: .cancel())
        }
       
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

struct PasswordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeView()
    }
}
