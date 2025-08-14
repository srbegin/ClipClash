//
//  LeaderView.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//

import SwiftUI
import AVKit
import NukeUI

//public enum SwipeState {
//        case left, right, justVoted
//}

struct LeaderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State var isContestLocked: Bool = true
    @State var voteButtonActive = 0
    @State var isLoading = true

//    @State var videoA = Video(id: 0, player: AVPlayer(), replay: false, profilePicUrl: "")
//    @State var videoB = Video(id: 0, player: AVPlayer(), replay: false, profilePicUrl: "")
    @State var videos: [Video] = [Video(id: 0, player: AVPlayer(), replay: false, profilePicUrl: ""),]
    
    @State var contestToVoteOn: String?
    @State var contestVotingOn: String?
//    @State var entries: [Entry] = []
    @State var swiped = false
//    @State var swipeState = SwipeState.justVoted
    @State var isMuted = false
    @State var animateShout = false
    @State var scale = 1.0
    
    @State var contest: Contest
//    @State var contestId: String?
    @State var videoPreloadCount = 10
    
    var body: some View{
         ZStack{
             
             TabView() {
                 ForEach(network.entries, id: \.id) { entry in
                     Player(player: AVPlayer(url: URL(string: entry.media_item.video_url)!))
                         .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                         .edgesIgnoringSafeArea(.all)
                         .navigationBarHidden(true)
                         //.padding(.bottom)
                 }
             }
             .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//             LeaderScrollView(videos: $videos)
//                 .edgesIgnoringSafeArea(.all)
//             ThursPlayerView(url: "https://upcdn.io/12a1xqj/raw/uploads/2022/11/11/file-32q7.mp4")
                 
             
            // Contest title and "lock contest" toggle
             VStack{
                 HStack {
                     ZStack {
                         HStack {
                             Button {
                                 presentationMode.wrappedValue.dismiss()
                             } label: {
                                 Label {
                                 } icon: {
                                     Image(systemName: "chevron.left")
                                         .font(Font.system(.title).bold())
                                 }
                                 .foregroundColor(.white)
                             }
                             .padding(.leading)
                             .padding(.top)
                             
                             Spacer()
                         }
                         HStack {
                             Spacer()
                             Text(self.contest.name.trimmingCharacters(in: .whitespacesAndNewlines))
                                 .font(Font.h5).foregroundColor(.white).padding(.top)
                             Spacer()
                         }
                     }
                     .padding(.bottom)
                 }.padding(.top, 30)
                 
                 Spacer()
             }
//
//                Spacer()
//
//                HStack{
//
//                    Spacer()
//
//                    VStack(spacing: 35){
//                        //Spacer()
//
//                        // COIN
//                        Button(action: {
//                            print("Coin tapped")
//                        }) {
//                            VStack(spacing: 8){
//                                Image("Coin Simple")
//                                    .font(.title)
//                                    .foregroundColor(.white)
//                            }
//                        }
//
//                        // SHARE
//                        Button(action: {
//                            actionSheet()
//                        }) {
//                            VStack(spacing: 8){
//                                Image(systemName: "arrowshape.turn.up.right.fill")
//                                    .font(.title)
//                                    .foregroundColor(.white)
//                            }
//                        }
//
//                        // MUTE
//                        Button(action: {
//                            if self.isMuted {
//
//                                self.isMuted.toggle()
//                            } else {
//
//                                self.isMuted.toggle()
//                            }
//                        }) {
//                            VStack(spacing: 8){
//                                if self.isMuted {
//                                    Image(systemName: "speaker.slash")
//                                        .font(.title)
//                                        .foregroundColor(.white)
//                                } else {
//                                    Image(systemName: "speaker")
//                                        .font(.title)
//                                        .foregroundColor(.white)
//                                }
//                            }
//
//                        }
//                    }
//                    //.padding(.bottom, 30)
//                    .padding(.trailing)
//                }
//                    .offset(x:0, y: -150)
//
//
//            }
                
//             VStack {
//                 Spacer()
//                 HStack{
//
//                     ZStack {
//                         Button(action: {
//
//                         }){
////                             LazyImage(source: videoA.profilePicUrl, resizingMode: .aspectFill)
////                                 .clipShape(Circle())
////                                 .frame(width: 60, height: 60, alignment: .center)
//
//                         }
//
//                     }
//
//                     Spacer()
//
//                     Image("VS")
//                         .renderingMode(.template)
//                         .font(.title)
//                         .foregroundColor(Color.white.opacity(0.3))
//
//                     Spacer()
//                     ZStack {
//                         Button(action: {
//
//                         }){
////                             LazyImage(source: videoB.profilePicUrl, resizingMode: .aspectFill)
////                                 .clipShape(Circle())
////                                 .frame(width: 60, height: 60, alignment: .center)
//                         }
//
//                     }
//
//
//                 }
//                    .padding(.horizontal, 30)
//                    .padding(.bottom, 25)
////                    .offset(x:0, y: -20)
//             }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .task {
            if self.contestToVoteOn != self.contestVotingOn {
//                network.entries = []
                self.contestVotingOn = self.contestToVoteOn
            }

            do {
                try await network.getEntryLeaderboardByContest(id: String(self.contest.id!), limit: String(videoPreloadCount))
                print("got entries")
                self.videos[0] = Video(id: 0, player: AVPlayer(url: URL(string: network.entries[0].media_item.video_url)!), replay: false, profilePicUrl: "")
                network.entries.indices.forEach { index in
                    videos.append(Video(id: network.entries[index].id, player: AVPlayer(url: URL(string: network.entries[index].media_item.video_url)!), replay: true, profilePicUrl: network.entries[index].media_item.owner_profile_pic!))
                }
                print(videos)
                print(network.entries)
            } catch {
                self.errorHandling.handle(error: error, context: "VoteView, getting inital entries")
                print(error)
            }
        }
    }
    
    
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
}
struct LeaderViewView_Previews: PreviewProvider {
   
    static var previews: some View {
        LeaderView(contest: AppConstants.defaultContest)
    }
}



//
//class Host : UIHostingController<ContestDetailView>{
//
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//
//        return .lightContent
//    }
//}

struct LeaderPlayerView : View {
    
    @Binding var data : [Video]
    
    var body: some View{
        
        VStack(spacing: 0){
            
            ForEach(0..<self.data.count){i in
//                ThursPlayerView(url: "https://upcdn.io/12a1xqj/raw/uploads/2022/11/11/file-32q7.mp4")
                    LeaderPlayer(player: self.data[i].player)

                        // full screensize because were going to make paging...
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .offset(y: -5)
                    
                    
            }
        }
        .onAppear {
            
            // doing it for first video because scrollview didnt dragged yet...
            
            self.data[0].player.play()
            
            self.data[0].player.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.data[0].player.currentItem, queue: .main) { (_) in
                
                // notification to identify at the end of the video...
                
                // enabling replay button....
                self.data[0].replay = true
            }
        }
    }
}

struct LeaderPlayer : UIViewControllerRepresentable {
    
//    var player : AVPlayer
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController{
        
        let view = AVPlayerViewController()
        view.player = player
        view.showsPlaybackControls = false
        view.videoGravity = .resizeAspectFill
        view.requiresLinearPlayback = true
        return view
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player        
    }
}

struct LeaderScrollView : UIViewRepresentable {
    
    @Binding var videos : [Video]
    
    func makeCoordinator() -> Coordinator {
        
        return LeaderScrollView.Coordinator(parent1: self)
    }
    
    
    func makeUIView(context: Context) -> UIScrollView{
        
        let view = UIScrollView()
        
        let childView = UIHostingController(rootView: LeaderPlayerView(data: $videos))
//        let childView = UIHostingController(rootView: ThursPlayerView(url: "https://upcdn.io/12a1xqj/raw/uploads/2022/11/11/file-32q7.mp4"))
        
        
        childView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat((videos.count)))
        view.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat((videos.count)))
        
        
        view.addSubview(childView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        view.delegate = context.coordinator
        
        return view
    }
    
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat((videos.count)))

        for i in 0..<uiView.subviews.count{

            uiView.subviews[i].frame = CGRect(x: 0, y: 0,width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * CGFloat((videos.count)))
        }
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        
        var parent : LeaderScrollView
        var index = 0
        
        init (parent1 : LeaderScrollView) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            let currenrindex = Int(scrollView.contentOffset.y / UIScreen.main.bounds.height)
            
            if index != currenrindex{
                
                index = currenrindex
                
                for i in 0..<parent.videos.count{
                    
                    // pausing all other videos...
                    parent.videos[i].player.seek(to: .zero)
                    parent.videos[i].player.pause()
                }
                
                // playing next video...
                
                parent.videos[index].player.play()
                
                parent.videos[index].player.actionAtItemEnd = .none
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: parent.videos[index].player.currentItem, queue: .main) { (_) in
                    
                    // notification to identify at the end of the video...
                    
                    // enabling replay button....
                    self.parent.videos[self.index].replay = true
                }
                
                
            }
        }
        
    }
}


