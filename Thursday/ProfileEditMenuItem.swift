//
//  ProfileEditMenuItem.swift
//  Thursday
//
//  Created by Scott Begin on 12/15/22.
//

import SwiftUI

struct ProfileEditMenuItem: View {
    
    @State var label: String
    @State var value: String
    @State var type: ProfileAttributeType
    
    var body: some View {
        ZStack {
            HStack {
                Text(self.label)
                    //.foregroundColor(.black)
                    .font(.headline)
                Text(self.value)
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.leading, 20)
                Spacer()
            }.padding()
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Font.system(.title)).padding(.trailing)
            }
        }
    }
}

struct ProfileEditMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditMenuItem(label: "", value: "", type: .username)
    }
}
