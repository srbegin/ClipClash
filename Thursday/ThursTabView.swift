//
//  ThursTabView.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//

import SwiftUI

struct ThursTabView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userState: UserState
    
    @State var showPopUp = false
    @State var showModal =  false
    @State var isFullScreen = false
    @State var lastScreen = AppConstants.defaultScreen
    
        
    var body: some View {
            
        VStack (spacing: 0){
            
            switch viewRouter.currentPage {
            case .vote:
                if let userContestToVoteOn = userState.contestToVoteOn {
                    
                    VoteView(contestToVoteOn: String(userContestToVoteOn.contest_id))
                        .onAppear {
                            isFullScreen = true
//                            viewRouter.previousPage = .vote
                        }
                } else {
                    VoteView(contestToVoteOn: AppConstants.defaultVotingContest)
                        .onAppear {
                            isFullScreen = true
//                            viewRouter.previousPage  = .vote
                        }
                }
                
            case .contests:
//                ContestListView(contestBrowsingStatus: userState.contestBrowsingStatus!)
                ContestListView()
                    .onAppear {
                        isFullScreen = false
                        viewRouter.previousPage  = .contests
                    }
                
            case .capture:
                CaptureView()
                    .onAppear {
                        isFullScreen = true
                    }
                
            case .wallet:
                WalletView()
                    .onAppear {
                        isFullScreen = false
                        viewRouter.previousPage  = .wallet
                    }
            case .user:
                MeView()
                    .onAppear {
                        isFullScreen = false
                        viewRouter.previousPage  = .user
                    }
                
            }

            if !isFullScreen {
                ZStack (alignment: .bottom){

                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .vote, width: UIScreen.screenWidth/5, height: UIScreen.screenHeight/28,
                                   systemIconName: (viewRouter.currentPage == .vote) ? "CC-solid" : "CC-hollow", tabName: "Vote")

                        TabBarIcon(viewRouter: viewRouter, assignedPage: .contests, width: UIScreen.screenWidth/5, height: UIScreen.screenHeight/28,
                                   systemIconName: (viewRouter.currentPage == .contests) ? "icon-trophy-yellow" :  "icon-trophy-hollow", tabName: "Contests")

                        ZStack {

                            Circle()
                                .foregroundColor(.white)
                                .frame(width: UIScreen.screenWidth/9, height: UIScreen.screenWidth/9)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth/9-6 , height: UIScreen.screenWidth/9-6)
                                .foregroundColor(.black)
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                        }
                        .offset(y: -(UIScreen.screenHeight/28)/2)
                        .onTapGesture {
                            withAnimation {
                                viewRouter.currentPage = .capture
                            }
                        }

                        TabBarIcon(viewRouter: viewRouter, assignedPage: .wallet, width: UIScreen.screenWidth/5, height: UIScreen.screenHeight/28,
                                   systemIconName: (viewRouter.currentPage == .wallet) ? "icon-wallet-yellow" :  "icon-wallet-hollow", tabName: "Wallet")

                        TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: UIScreen.screenWidth/5, height: UIScreen.screenHeight/28,
                                   systemIconName: (viewRouter.currentPage == .user) ? "icon-user-yellow" :"icon-user-hollow", tabName: "Me")
                    }
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/28)
                    .padding(.bottom, 15)
                    .offset(x: 0, y: 15)
                    .background(Color.black).shadow(radius: 2)
                }
                .edgesIgnoringSafeArea(.bottom)
                .ignoresSafeArea(.keyboard)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
   
    }
    
    

    struct ThursTabView_Previews: PreviewProvider {

        static var previews: some View {
            
            ThursTabView()
                .preferredColorScheme(.light)
        }
    }


    struct TabBarIcon: View {
//        @EnvironmentObject var viewRouter: ViewRouter
        @StateObject var viewRouter: ViewRouter
        let assignedPage: Page
        
        let width, height: CGFloat
        let systemIconName, tabName: String

        var body: some View {
            VStack {
                Image(systemIconName)
                    //.renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .padding(.top, 10)
                Text(tabName).foregroundColor(Color.gray).font(.caption).offset(y: -6)
                Spacer()
            }
                .padding(.horizontal, -4)
                .onTapGesture {
                    viewRouter.currentPage = assignedPage
                }
//                .foregroundColor(viewRouter.currentPage == assignedPage ? Color(.yellow) : .gray)
//                .foregroundColor(.gray)
        }
    }



