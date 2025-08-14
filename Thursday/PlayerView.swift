//
//  PlayerViewTest.swift
//  Thursday
//
//  Created by Scott Begin on 10/25/22.
//

import SwiftUI
import AVKit

struct PlayerView : View {
    
    @Binding var videoA : Video
    @Binding var videoB : Video
    
    @State var isLoading = true
  
    var body: some View{
        
        HStack(spacing: 0){
            

                Player(player: videoA.player)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)// - (UIScreen.screenHeight/28))
                    .offset(y: 0)
            
                Player(player: videoB.player)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)// - (UIScreen.screenHeight/28))
                    .offset(y: 0)
        }
        .onAppear {
            
            self.videoA.player.play()
            self.videoA.player.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoA.player.currentItem, queue: .main) { (_) in
                self.videoA.player.seek(to: .zero)
            }
        }
        .onDisappear {
            self.videoA.player.pause()
            self.videoB.player.pause()
        }
    }
}

struct Player : UIViewControllerRepresentable {
    
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController{
        
        let view = AVPlayerViewController()
        view.player = player
        view.showsPlaybackControls = false
        view.videoGravity = .resizeAspectFill
//        view.videoGravity = .resizeAspect
        view.requiresLinearPlayback = true
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
        
    }
    
    
}
