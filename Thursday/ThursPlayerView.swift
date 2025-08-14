//
//  ThursPlayer.swift
//  Thursday
//
//  Created by Scott Begin on 11/23/22.
//

import AVFoundation
import AVKit
import UIKit
import SwiftUI

struct ThursPlayerView: UIViewControllerRepresentable {
    
    var url: String
//    var playingImageName: String?
//    var pausedImageName: String?
    
    func makeUIViewController(context: Context) -> ThursViewController {
        
        let vc = ThursViewController()
        vc.url = self.url
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ThursViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    

}

class ThursViewController: UIViewController {
    
    var tap: UITapGestureRecognizer?
    
    var playPauseButton: PlayPauseButton!
//    var playPauseButton = PlayPauseButton()
    var url : String = "error"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: self.url) else { return }

        let player = AVPlayer(url: url)
        player.rate = 0
        let playerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = playerFrame
        playerViewController.showsPlaybackControls = false
        if #available(iOS 16.0, *) {
            playerViewController.allowsVideoFrameAnalysis = false
        }
        

        addChild(playerViewController)
        view.addSubview(playerViewController.view)
//        playerViewController.didMove(toParent: self)
        
        playPauseButton = PlayPauseButton()
//        playPauseButton.playingImageName = playingImageName
//        playPauseButton.pausedImageName = pausedImageName
        playPauseButton.avPlayer = player
        view.addSubview(playPauseButton)
        playPauseButton.setup(in: self)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { (_) in
            player.seek(to: .zero)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playPauseButton.updateUI()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transitioning")
        super.viewWillTransition(to: size, with: coordinator)
        

//        playPauseButton.updateUI()
    }
}

class PlayPauseButton: UIView {
    var kvoRateContext = 0
    var avPlayer: AVPlayer?
//    var playingImageName: String = ""
    var pausedImageName: String = "playbutton-t-yellow"
//    var pausedImageName: String = "play"
    
    var isPlaying: Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
    }

    func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: "rate", options: .new, context: &kvoRateContext)
    }

    func setup(in container: UIViewController) {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        updatePosition()
        updateUI()
        addObservers()
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        updateStatus()
        updateUI()
    }

    private func updateStatus() {
        if isPlaying {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
    }

    func updateUI() {
        if isPlaying {
//            setBackgroundImage(name: playingImageName)
        } else {
            setBackgroundImage(name: pausedImageName)
        }
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 100),
            heightAnchor.constraint(equalToConstant: 100),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
    }

    private func setBackgroundImage(name: String) {
//        UIGraphicsBeginImageContext(frame.size)
        UIImage(systemName: "play")?.draw(in: bounds)
//        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
//        UIGraphicsEndImageContext()
//        backgroundColor = UIColor(patternImage: image)
//        backgroundColor = UIColor(Color.primaryYellow500)
    }
    

    private func handleRateChanged() {
        updateUI()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else { return }

        switch context {
        case &kvoRateContext:
            handleRateChanged()
        default:
            break
        }
    }
}
