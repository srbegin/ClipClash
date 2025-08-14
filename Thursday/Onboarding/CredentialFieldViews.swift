//
//  CredentialFieldViews.swift
//  Thursday
//
//  Created by Scott Begin on 1/24/23.
//

import SwiftUI
import Foundation
import Combine


struct EmailInputView: View {
    var placeHolder: String = ""
    @Binding var txt: String
    
    var body: some View {
        TextField("", text: $txt)
            .placeholder(when: txt.isEmpty) {
                   Text(placeHolder).foregroundColor(.gray)
           }
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .onReceive(Just(txt)) { newValue in
                let validString = newValue.filter { "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._-+$!~&=#[]@".contains($0) }
                if validString != newValue {
                    self.txt = validString
                }
            }
            .foregroundColor(.black)
    }
}

struct PasswordInputView: View {
    var placeHolder: String = ""
    @Binding var txt: String
    
    
    var body: some View {
        SecureField("", text: $txt, prompt: Text("Password"))
            .placeholder(when: txt.isEmpty) {
                   Text(placeHolder).foregroundColor(.gray)
           }
            .textContentType(.password)
            .foregroundColor(.black)
            .onReceive(Just(txt)) { newValue in
                
                let validString = newValue.filter { "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._-+$!~&=#[]@".contains($0) }
                if validString != newValue {
                    self.txt = validString
                }
        }
    }
}

struct PasswordSetView: View {
    var placeHolder: String = ""
    @Binding var txt: String
    @Binding var feedback: [String]
    
    var body: some View {
        SecureField("", text: $txt, prompt: Text("Password"))
            .placeholder(when: txt.isEmpty) {
                   Text(placeHolder).foregroundColor(.gray)
           }
            .textContentType(.password)
            .foregroundColor(.black)
            .onReceive(Just(txt)) { newValue in
                
                let validString = newValue.filter { "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._-+$!~&=#[]@".contains($0) }
                if validString != newValue {
                    self.txt = validString
                }
                
                if newValue.count < 8 {
                    feedback[0] = "Password must be at least 8 characters"
                    } else { feedback[0] = "" }
                
                if newValue.range(of: #"\d+"#, options: .regularExpression) == nil {
                    feedback[1] = "Password must contain at least one digit"
                } else { feedback[1] = "" }
                
                if newValue.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
                    feedback[2] = "Password must contain at least one letter"
                } else { feedback[2] = "" }
        }
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
