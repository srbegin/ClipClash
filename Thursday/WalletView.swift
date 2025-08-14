//
//  WalletView.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//

import SwiftUI
import AVKit

struct WalletView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userState: UserState
    @Environment(\.presentationMode) var presentationMode
    @State private var isSubmitPresented = false
   
    
    var body: some View {
            
            VStack(spacing: 0) {
//                SignInView().background(Color.white)
                Spacer()
                Text("Wallet coming soon...")
                
//                VStack(spacing: 0) {
//                    Text("Contest to enter chosen?: "+String(userState.contestToEnterChosen)).font(.system(size: 18, weight: .bold)).foregroundColor(Color.black)
//                    Text("Entry captured?: "+String(userState.entryCaptured)).font(.system(size: 18, weight: .bold)).foregroundColor(Color.black)
//                    Text("Contest to vote on: "+String(userState.contestToVoteOn!.name)).font(.system(size: 18, weight: .bold)).foregroundColor(Color.black)
//                    Text("Contest to enter: "+String(userState.contestToEnter!.name)).font(.system(size: 18, weight: .bold)).foregroundColor(Color.black)
//                    Text("ID: "+String(userState.userModel.user_id)).foregroundColor(Color.black)
//                    Text("Username: "+userState.userModel.username).foregroundColor(Color.black)
//                    Text("Pic: "+userState.userModel.profile_pic!).foregroundColor(Color.black)
////                    Text("Contest: "+userState.userModel.last_contest_viewed!).foregroundColor(Color.black)
//                    Text("Credits: "+String(userState.userModel.credits)).foregroundColor(Color.black)
//                    Text("Token: "+userState.token).foregroundColor(Color.black)
//                }.background(Color.white)

                        Spacer()
            }
                .background(Color.white)
               
    }
    
    
    
  
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
