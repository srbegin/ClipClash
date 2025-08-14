//
//  VoteView.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//

import SwiftUI
import AVKit
import NukeUI


struct LeaderboardView: View {
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var errorHandling: ErrorHandling
    
    
    
    @State var isLoading = true
    @State var videos: [Video] = [Video(id: 0, player: AVPlayer(), replay: false, profilePicUrl: "")]
//    @State var videos: [Video] = []
    
    @State var contestId: String
    @State var videoCount = "10"
    @State var isMuted = false
    @State var animateShout = false
    @State var scale = 1.0
    
    
    var body: some View{
        ZStack {
            LeaderboardScrollView(videos: self.$videos)
                .task {
                    do {
                        try await network.getEntryLeaderboardByContest(id: contestId, limit: videoCount)
                        print(network.entries)
                        network.entries.indices.forEach { index in
                            videos.append(Video(id: network.entries[index].id, player: AVPlayer(url: URL(string: network.entries[index].media_item.video_url)!), replay: true, profilePicUrl: network.entries[index].media_item.owner_profile_pic!))
                        }
                        
                        print(videos)
                    } catch {
                        self.errorHandling.handle(error: error, context: "VoteView, getting inital entries")
                        print(error)
                    }
                }
                .edgesIgnoringSafeArea(.all)
            
//            Text("Hello")
        }

    }
    
   
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
}
struct LeaderboardView_Previews: PreviewProvider {
   
    static var previews: some View {
        LeaderboardView(contestId: "1")
    }
}



struct LeaderboardPlayerView : View {
    
    @Binding var videos : [Video]
    
    var body: some View{
        
        VStack(spacing: 0){
            
            ForEach(0..<self.videos.count){i in
                
//                ZStack{
                    
                    Player(player: self.videos[i].player)
                        // full screensize because were going to make paging...
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .offset(y: -5)
                    
//                    Text("There")
//
//
//
//                }
            }
        }
        .onAppear {
            
            // doing it for first video because scrollview didnt dragged yet...
            
            self.videos[0].player.play()
            
            self.videos[0].player.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videos[0].player.currentItem, queue: .main) { (_) in
                
                // notification to identify at the end of the video...
                
                // enabling replay button....
                self.videos[0].replay = true
            }
        }
    }
}


struct LeaderboardScrollView : UIViewRepresentable {
    
    @Binding var videos : [Video]
    
    func makeCoordinator() -> Coordinator {
        
        return LeaderboardScrollView.Coordinator(parent1: self)
    }
    
       
    func makeUIView(context: Context) -> UIScrollView{
        
        let view = UIScrollView()
        
        let childView = UIHostingController(rootView: LeaderboardPlayerView(videos: $videos))
        
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
        
        var parent : LeaderboardScrollView
        var index = 0
        
        init (parent1 : LeaderboardScrollView) {
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


