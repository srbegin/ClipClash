//
//  RegistrationChooseProfilePhoto.swift
//  Thursday
//
//  Created by Scott Begin on 12/19/22.
//

import SwiftUI

struct RegistrationChooseProfilePhoto: View {
    
    @State var newUser: User
    
    var body: some View {
        VStack {
            Text("Choose a profile photo").font(Font.h3).foregroundColor(.black)
            Text("You can always change this later").font(Font.h5).foregroundColor(.black)
            ProfilePhotoChooser(user: newUser)
                .padding()
                .task {
                    self.newUser = await LoginManager().getUserById(id: String(UserDefaults.standard.integer(forKey: "userId")))
                }
            
            Button(action: {
                ThursdayApp.Authenticated.send(true)
            }){ Text("All Done!").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
            }.frame(width:300).buttonStyle(YellowWideButton())
                .padding()
            
            Spacer()
        }
    }
}

struct RegistrationChooseProfilePhoto_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationChooseProfilePhoto(newUser: AppConstants.defaultUser)
    }
}
