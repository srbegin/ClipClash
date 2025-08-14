//
//  VoteView.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//

import SwiftUI
import AVKit
import NukeUI

public enum SwipeState {
        case left, right, justVoted
}

struct VoteView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var errorHandling: ErrorHandling
    
    let videoPreloadCount = "20"
    @State var requiredWatchFactor: CGFloat = 0.3
    
    @State var isContestLocked: Bool = true
    @State var voteButtonActive = 0
    @State var voteButtonSwell = false
    @State var isLoading = true

    @State var videoA = Video()
    @State var videoB = Video()
    @State var videos: [Video] = []
    
    @State var contestToVoteOn: String?
    @State var contestVotingOn: String?
    @State var swiped = false
    
    @State var swipeState = SwipeState.justVoted
    @State var isMuted = false
    @State var animateShout = false
    @State var scale = 1.0
    
     var myProgress = 0.0
       
    struct ProgressBar: View {
        var percentFilled: CGFloat
        var width, height: CGFloat
        
        var body: some View {
            ZStack {
//                if (percentFilled > 0) {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: width, height: height)
                        .overlay(
                            Circle().trim(from:0, to: percentFilled)
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 3,
                                        lineCap: .round,
                                        lineJoin:.round
                                    )
                                )
                            //                        .foregroundColor(
                            //                            ((percentFilled >= 1) ? Color.green : Color.yellow)
                                .foregroundColor(Color.primaryYellow300)
                            
                                .animation(
                                    .easeInOut(duration: 1)
                                )
                        )
//                }
            }
        }
        

    }
    
    func triggerVoteButtonSwell() {
        voteButtonSwell = true
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).repeatCount(1)) {
                        voteButtonSwell.toggle()
        }
    }
    
    
    var body: some View{
        
         ZStack{
             PlayerSwipeView(videoA: $videoA, videoB: $videoB, swipeState: $swipeState, requiredWatchFactor: $requiredWatchFactor)
                 .task {
                     print("in task")

                     if self.contestToVoteOn != self.contestVotingOn {
                         network.entries = []
                         self.contestVotingOn = self.contestToVoteOn
                     }
                     
                     do {
                         try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                    }
                    catch {
                        print("Setting category to AVAudioSessionCategoryPlayback failed.")
                    }
//                     try! AVAudioSession.sharedInstance().setCategory(.playback, options: []) //ensures volume on
//                     try! AVAudioSession.sharedInstance().setCategory(.playback)

                     do {
                         //Getting the entry info
                         let newEntries = try await network.getEntriesToVoteOn(contestId: String(self.contestVotingOn!), entryCount: videoPreloadCount)
                         
                         //Loading up video array
                         newEntries.indices.forEach { index in
                             let myVideo = Video(id: newEntries[index].id, player: AVPlayer(url: URL(string: newEntries[index].media_item.video_url)!), replay: true, profilePicUrl: newEntries[index].media_item.owner_profile_pic!)
                             
//                             myVideo.player.pause() //does this help at all??

                             videos.append(myVideo)
                         }
                     } catch {
                         self.errorHandling.handle(error: error, context: "VoteView, getting inital entries")
                         print(error)
                     }
                     
                     prepareNewVideoPair()
                     
                 }
                 .edgesIgnoringSafeArea(.all)
                 
             
            VStack{
                HStack {
                    ZStack {
                        HStack {
                            Button {
                                viewRouter.currentPage = viewRouter.previousPage
                            } label: {
                                Label {
                                } icon: {
                                    Image(systemName: "chevron.left")
                                        .font(Font.system(.largeTitle).bold())
                                }
                                .foregroundColor(.white)
                            }
//                            .contentShape(Rectangle())
                            .padding(.leading)
                            .padding(.top)

                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text(userState.contestToVoteOn!.name.trimmingCharacters(in: .whitespacesAndNewlines))
                                .font(Font.h5).foregroundColor(.white).padding(.top)
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                }.padding(.top, 30)

                Spacer()

                HStack{

                    Spacer()

                    VStack(spacing: 35){
                        
                        // SHARE
                        Button(action: {
                            actionSheet()
                        }) {
                            VStack(spacing: 8){
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // MUTE
                        Button(action: {
                            if self.isMuted {
                                videoA.player.isMuted = false
                                videoB.player.isMuted = false
                                self.isMuted.toggle()
                            } else {
                                videoA.player.isMuted = true
                                videoB.player.isMuted = true
                                self.isMuted.toggle()
                            }
                        }) {
                            VStack(spacing: 8){
                                if self.isMuted {
                                    Image(systemName: "speaker.slash")
                                        .font(.title)
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "speaker")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                        }//.contentShape(Rectangle())
                    }
                    .padding(.trailing)
                }
                    .offset(x:0, y: -150)

                
            }
                
             VStack {
                 Spacer()
                 HStack{
                     
                     ZStack {
                         
                         LazyImage(source: videoA.profilePicUrl, resizingMode: .aspectFill)
                             .clipShape(Circle())
                             .frame(width: 60, height: 60, alignment: .center)
                             .opacity(swipeState == SwipeState.left || swipeState == SwipeState.justVoted ? 1 : 0.4 )
                         
//                         if (swipeState == SwipeState.left || swipeState == SwipeState.justVoted) {
//                             Image("Shout")
//                                 .renderingMode(.template)
//                                 .font(.headline)
//                                 .foregroundColor(Color.primaryYellow300)
//                                 .offset(x: 44)
//                         }
                         
                         if videoA.player.status == AVPlayer.Status.readyToPlay {
                             ProgressBar(percentFilled: videoA.progress/videoA.interval , width: 64, height: 64)
                                 .opacity(swipeState == SwipeState.left || swipeState == SwipeState.justVoted ? 1 : 0.4 )
                         }
                     }
                     
                     Spacer()
                     
                     ZStack {
                         HStack {
                             RoundedRectangle(cornerRadius: 3).fill(Color.primaryYellow300).frame(width: 60, height: 3, alignment: .center).offset(x: -34.0, y: 0.0)
                                 .opacity((swipeState == SwipeState.left || swipeState == SwipeState.justVoted) ? 1 : 0.4)
                             
                             RoundedRectangle(cornerRadius: 3).fill(Color.primaryYellow300).frame(width: 60, height: 3, alignment: .center).offset(x: 34.0, y: 0.0)
                                 .opacity((swipeState == SwipeState.right) ? 1 : 0.4)
                         }
                             
                         Button(action: {
                         }){
                             Image(systemName: "hand.thumbsup.circle").font(.system(size: 55, weight: .light))
                             //                                 .foregroundColor((videoA.okToVote && videoB.okToVote) ? .green : .yellow)
                                 .foregroundColor(Color.primaryYellow300)
                                 .aspectRatio(1.0, contentMode: .fit)
                                 .opacity((videoA.okToVote && videoB.okToVote) ? 1 : 0.4 )
                                 .scaleEffect(voteButtonSwell ? 1.3 : 1)
                                 .animation(.easeInOut(duration: 0.3))
                                 .onTapGesture {
                                     //                                         triggerVoteButtonSwell()
                                     
                                     if (swipeState == SwipeState.left || swipeState == SwipeState.justVoted) {
                                         castVote(buttonId: 0)
                                     } else if (swipeState == SwipeState.right) {
                                         castVote(buttonId: 1)
                                     }
                                 }
                                 .onChange(of: (videoA.okToVote)) { _ in
                                     if videoA.okToVote && videoB.okToVote {
                                         voteButtonSwell = true
                                     } else { voteButtonSwell = false }
                                 }
                                 .onChange(of: (videoB.okToVote)) { _ in
                                     if videoA.okToVote && videoB.okToVote {
                                         voteButtonSwell = true
                                     } else { voteButtonSwell = false }
                                 }
                         }
                             
                             
                         
                     }
                     
                     Spacer()
                     
                     ZStack {
                         
//                         if (swipeState == SwipeState.right) {
//                             Image("Shout_rev")
//                                 .renderingMode(.template)
//                                 .font(.body)
//                                 .foregroundColor(Color.primaryYellow300)
//                                 .offset(x: -44)
//                         }

                         LazyImage(source: videoB.profilePicUrl, resizingMode: .aspectFill)
                             .clipShape(Circle())
                             .frame(width: 60, height: 60, alignment: .center)
                             .opacity(swipeState == SwipeState.right ? 1 : 0.4 )
                         
                         if videoB.player.status == AVPlayer.Status.readyToPlay {
                             ProgressBar(percentFilled: videoB.progress/videoB.interval , width: 64, height: 64)
                                 .opacity(swipeState == SwipeState.right ? 1 : 0.4 )
                         }
                         
                     }
                     
                 }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 25)
//                    .offset(x:0, y: -20)
             }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onChange(of: scenePhase) { (phase) in
            switch phase {
            case .active: print("ScenePhase: active")
            case .background:
                print("ScenePhase: background")
                
            case .inactive: print("ScenePhase: inactive")
            @unknown default: print("ScenePhase: unexpected state")
            }
        }
    }
    
    func castVote(buttonId: Int) {
        videoA.player.pause()
        videoB.player.pause()
        
        do {
            if buttonId == 0 {
                print("Vote cast for entry: "+String(videoA.id))
                try network.castVote(voterId: String(userState.userModel.id), entryChosen: String(videoA.id), entryDeclined: String(videoB.id))
            } else if buttonId == 1 {
                print("Vote cast for entry: "+String(videoB.id))
                try network.castVote(voterId: String(userState.userModel.id), entryChosen: String(videoB.id), entryDeclined: String(videoA.id))
            }
        } catch {
            print("Error in castVote()")
        }
        
        videoA.okToVote = false
        videoB.okToVote = false
        
        nextTwoEntries()
    }
    
    func nextTwoEntries() {
        
        swipeState = SwipeState.justVoted
        
        prepareNewVideoPair()
        
        Task {
            do {
                let newEntries = try await network.getEntryPair(contestId: String(self.contestVotingOn!))
                newEntries.indices.forEach { index in
                    
                videos.append(Video(id: newEntries[index].id, player: AVPlayer(url: URL(string: newEntries[index].media_item.video_url)!), replay: true, profilePicUrl: newEntries[index].media_item.owner_profile_pic!))
                }
            } catch {
                self.errorHandling.handle(error: error, context: "VoteView, getting entry pair")
                print(error)
            }
        }
    }
    
    func prepareNewVideoPair() {
        
        if videos.indices.contains(0) && videos.indices.contains(1){
            videoA = videos[0]
            videoB = videos[1]
            
            videoA.player.automaticallyWaitsToMinimizeStalling = true
            videoB.player.automaticallyWaitsToMinimizeStalling = true
            
            if self.isMuted {
                videoA.player.isMuted = true
                videoB.player.isMuted = true
            } else {
                videoA.player.isMuted = false
                videoB.player.isMuted = false
            }
            
            if let vidItemA = videoA.player.currentItem, let vidItemB = videoB.player.currentItem {
                var timesA = [NSValue]()
                var timesB = [NSValue]()
                let currentTime = CMTime.zero
                let intervalA = CMTimeMultiplyByFloat64(vidItemA.asset.duration, multiplier: requiredWatchFactor)
                videoA.interval = CMTimeGetSeconds(intervalA)
                videoA.progress = 0
                
                let intervalB = CMTimeMultiplyByFloat64(vidItemB.asset.duration, multiplier: requiredWatchFactor)
                videoB.interval = CMTimeGetSeconds(intervalB)
                videoB.progress = 0

                timesA.append(NSValue(time: currentTime + intervalA))
                timesB.append(NSValue(time: currentTime + intervalB))
                
                
                videoA.player.addBoundaryTimeObserver(forTimes: timesA, queue: .main) { ()  in
                    videoA.okToVote = true
                    print(videoA.progress)
                }
                
                
//                let interval = CMTime(value: 1, timescale: 2)
////                let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//
//                videoA.player.addPeriodicTimeObserver(forInterval: interval	 , queue: DispatchQueue.global(qos: .background)) { time in
//                    if (videoA.progress < videoA.interval) {
//                        print(videoA.progress/videoA.interval)
////                        videoA.progress += 0.5
//                        videoA.progress = CGFloat(CMTimeGetSeconds(videoA.player.currentTime()))
//                    }
//                    }
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
//                    print("tick...")
                    if (swipeState == SwipeState.left || swipeState == SwipeState.justVoted) &&
                        videoA.player.timeControlStatus == .playing &&
                        (videoA.progress < videoA.interval) {
                        print("VidA progress: ")
                        print(videoA.progress)
                        print("of: ")
                        print(videoA.interval)
                        print()
//                        videoA.progress += 0.5
                        videoA.progress = CGFloat(CMTimeGetSeconds(videoA.player.currentTime()))
                    }

                    if swipeState == SwipeState.right &&
                        videoB.player.timeControlStatus == .playing &&
                        (videoB.progress < videoB.interval) {
                        print("VidB progress: ")
                        print(videoB.progress)
                        print("of: ")
                        print(videoB.interval)
                        print()
//                        videoB.progress += 0.5
                        videoB.progress = CGFloat(CMTimeGetSeconds(videoB.player.currentTime()))
                    }

                    if (videoA.okToVote && videoB.okToVote) || viewRouter.currentPage != .vote {
                            timer.invalidate()
                        }
                }


                videoB.player.addBoundaryTimeObserver(forTimes: timesB, queue: .main) { ()  in
                    videoB.okToVote = true
                    print(videoB.progress)
                }
            }
            
            videos = Array(videos[2..<videos.count])
            print(String(videoA.id)+" vs "+String(videoB.id))
        } else {
            videoA = Video(id: 0, player: AVPlayer(), replay: false, profilePicUrl: "")
            videoB = Video(id: 0, player: AVPlayer(), replay: false, profilePicUrl: "")
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
}
struct VoteView_Previews: PreviewProvider {
   
    static var previews: some View {
        VoteView()
    }
}


struct Video : Identifiable {

    var id = 0
    var player = AVPlayer()
    var replay = true
    var profilePicUrl = ""
    var progress: CGFloat = 0
    var interval: CGFloat = 0
    var okToVote = false
}

class Host : UIHostingController<ThursTabView>{

    override var preferredStatusBarStyle: UIStatusBarStyle{

        return .lightContent
    }
}

struct PlayerSwipeView : UIViewRepresentable {
    
    @Binding var videoA : Video
    @Binding var videoB : Video
    @Binding var swipeState: SwipeState
    @Binding var requiredWatchFactor: CGFloat

    
    func makeCoordinator() -> Coordinator {
        
        return PlayerSwipeView.Coordinator(parent1: self)
    }
    
    
    func makeUIView(context: Context) -> UIScrollView{
        print("make called")
        let view = UIScrollView()
        
       
        let childView = UIHostingController(rootView: PlayerView(videoA: $videoA, videoB: $videoB))
        
        childView.view.frame = CGRect(x: 0, y: -15, width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)// - (UIScreen.screenHeight/28))
        
        view.contentSize = CGSize(width: UIScreen.main.bounds.width * 2 , height: UIScreen.main.bounds.height)// - (UIScreen.screenHeight/28))
        view.addSubview(childView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        view.delegate = context.coordinator
        
        return view
    }
    
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        print("update called")
        if swipeState == .justVoted {
//            print("VidA interval:")
//            print(videoA.interval)
//            let interval = CMTime(value: 1, timescale: 1)
//            videoA.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { time in
//                if (videoA.progress < videoA.interval) {
////                    print(videoA.progress/videoA.interval)
//                    videoA.progress += 0.5
//                }
//                }
            
            uiView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            videoA.player.play()
            videoA.player.actionAtItemEnd = .none

            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoA.player.currentItem, queue: .main) { (_) in
                videoA.player.seek(to: .zero)
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoB.player.currentItem, queue: .main) { (_) in
                videoB.player.seek(to: .zero)
            }
            
        }
    }
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        
        var parent : PlayerSwipeView
        
        init (parent1 : PlayerSwipeView) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            let scrollFactor =   Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)

            if scrollFactor == 0 {

//                parent.updateSwipeState(swipeState: SwipeState.left)
                DispatchQueue.main.async { self.parent.swipeState = SwipeState.left }
                parent.videoB.player.pause()
                parent.videoA.player.play()
                parent.videoA.player.actionAtItemEnd = .none

            } else {
                DispatchQueue.main.async { self.parent.swipeState = SwipeState.right }
                parent.videoA.player.pause()
                parent.videoB.player.play()
                parent.videoB.player.actionAtItemEnd = .none

            }
        }
    }
    
}



public extension UIApplication {
    func currentUIWindowTest() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
