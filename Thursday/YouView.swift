//
//  YouView.swift
//  Thursday
//
//  Created by Scott Begin on 12/16/22.
//

import SwiftUI
import AVKit
import NukeUI

struct YouView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var isPresenting: MediaItem? = nil
    @State var showingSheet = false
    @State var youId: Int
    
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        viewRouter.currentPage = viewRouter.previousPage
                    } label: {
                        Label {
                        } icon: {
                            Image(systemName: "chevron.left")
                                .font(Font.system(.title).bold())
                        }
                        .foregroundColor(.black)
                    }
                    .padding(.leading)
                    .padding(.top)

                    Spacer()
                }
                
                VStack {
                    Text("@"+userState.userModel.username).font(Font.h3).foregroundColor(.black)
                    Text(userState.userModel.first_name+" "+userState.userModel.last_name).font(Font.body1).foregroundColor(.gray)
                }.padding(.top)
            }
            
            HStack {
                Spacer()
                
                LazyImage(source: userState.userModel.profile_pic, resizingMode: .aspectFill)
                    .clipShape(Circle())
                    .frame(width: 150, height: 150, alignment: .center)
                    .padding(.top)
                
                Spacer()
            }.padding(.bottom, 10)
            
            ProfileMediaGridView(userId: self.youId)
            
            Spacer()
            
        }.background(Color.white)
    }
    
    struct MyButtonStyle: ButtonStyle {
      let navyBlue = Color(red: 0, green: 0, blue: 0.5)
      
      func makeBody(configuration: Configuration) -> some View {
        configuration.label
          .padding()
          .background(navyBlue)
          .foregroundColor(.white)
          .clipShape(Capsule())
      }
    }
}

struct YouView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
