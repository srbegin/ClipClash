//
//  ContestDetailView.swift
//  Thursday
//
//  Created by Scott Begin on 10/19/22.
//

import SwiftUI
import AVKit
import NukeUI

struct ContestDetailView: View {
    
//    @EnvironmentObject var network: Network
    @StateObject var network = Network()
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var contest : Contest
    @State var explainerVidPlayer = AVPlayer()
    @State var isPresenting = false
    @State var isPresentingEntry: Entry?
    @State var showingLeaderboard = false
    
    @State private var isSubmitPresented = false
    
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
        ScrollView {

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
                        .foregroundColor(.black)
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Contest Details").font(Font.h5).foregroundColor(.black).padding(.top)
                    Spacer()
                }
            }
            .padding(.bottom)
                        
            VStack {
                    Spacer()
                    HStack {
                        VStack (alignment: .center) {
                            ZStack {
                                HStack {
                                    
                                    VStack (alignment: .leading){
                                        HStack { Spacer() }
                                        Text(contest.name).font(Font.h3).padding(.horizontal).foregroundColor(Color.black)
                                        Text("Created by Thursday Team").font(.subheadline).foregroundColor(Color.black).padding(.horizontal)
                                        Text(String(contest.contestant_count)+" Contestants").font(.subheadline).foregroundColor(Color.black).padding(.horizontal)
                                        HStack(alignment: .bottom){
                                            if (contest.status == "OPENACTIVE" || contest.status == "OPEN") {
                                                Chip(titleKey: "ENTER", backgroundColor: Color.primaryYellow300, textColor: Color.neutral700)
                                            }
                                            if (contest.status == "OPENACTIVE" || contest.status == "ACTIVE") {
                                                Chip(titleKey: "VOTE", backgroundColor: Color.primaryYellow300, textColor: Color.neutral700)
                                            }
                                            if (!contest.prize.isEmpty) {
                                                Chip(titleKey: contest.prize, backgroundColor: Color.neutral700, textColor: Color.primaryYellow300)
                                            }
                                            Spacer()
                                        }.padding(.leading)
                                            .frame(width: 250)
                                        Spacer()
                                    }.frame(width: 300)
                                    Spacer()
                                }
                                
                                HStack {
                                    Spacer()
                                    LazyImage(source: contest.image_url, resizingMode: .aspectFit)
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .padding()
                                    
                                    //                                Image("Contestant").padding()
                                }
                            }
                            
                            //Add to Faves button
                            
                            Text(contest.description).font(.caption).foregroundColor(Color.black).lineLimit(10).padding()
                            
                            Spacer()
                            
                            if contest.status == "FUTURE" {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Submissions Start:").font(.footnote).bold()
                                        Text(getFormattedDate(dateString: contest.submit_start, format: "LLLL dd")+" at "+getFormattedDate(dateString: contest.submit_start, format: "HH:mm"))
                                            .font(.footnote)
                                    }.padding()
                                    Spacer()
                                }
                            }

                            
                            if contest.status == "OPEN" || contest.status == "FUTURE" {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Voting Starts:").font(.footnote).bold()
                                        Text(getFormattedDate(dateString: contest.voting_start)).font(.footnote)
                                    }.padding()
                                    Spacer()
                                }
                            }
                            
                            CustomPlayerView(player: AVPlayer(url: URL(string: contest.video_url!)!))
                                .frame(height: UIScreen.main.bounds.height / 3.5)
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 275, height: 275)
                            
//                            Player(player: AVPlayer(url:  URL(string: contest.video_url!)!))
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 275, height: 275)

//                            ThursPlayerView(url: contest.video_url!)
////                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 275, height: 275)
                                Spacer()
                         
                            
//                            HStack {
//                                Button(action: {
//                                    showingLeaderboard = true
//                                }){
//                                    Text("Leaderboard").font(Font.h4).padding()
//                                }
//                            }
//                            .fullScreenCover(isPresented: $showingLeaderboard) {
//                                LeaderView(contest: contest, videoPreloadCount: 10)
//                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Leaderboard").font(Font.h4).padding(.leading)
                                    Spacer()
                                    Text(String(contest.contestant_count)+" Contestants").font(.overline1).padding(.trailing)
                                }.padding(.top)
                              
                                ForEach(network.entries, id: \.id) { entry in
                                    ZStack {
                                        HStack {
                                            
                                            LazyImage(source: entry.media_item.owner_profile_pic, resizingMode: .aspectFill)
                                                .clipShape(Circle())
                                                .frame(width: 70, height: 70, alignment: .center)
                                                .padding(.leading)
                                           
                                            
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text(entry.media_item.name).font(Font.h4).foregroundColor(.black)
                                                Text("@"+String(entry.media_item.owner_username!)).font(.body).foregroundColor(.black)
                                            }
                                            
                                            Spacer()
                                        }
                                        .frame(alignment: .leading)
                                        .padding(.bottom)
                                        //                                    .background(.white)
                                        
                                        HStack {
                                            Spacer()
                                            Text(String(entry.score!)).foregroundColor(.black)
                                        }.padding(.trailing, 15)
                                    }
                                }
                                
                                VStack {
                                    HStack { Spacer()}
                                }.frame(height: 200)
                            }
                            .padding(.top)
                            .task {
                                do {
                                    try await network.getEntryLeaderboardByContest(id: String(contest.id!), limit: "10")
                                } catch {
                                    self.errorHandling.handle(error: error, context: "ContestListView searchChange")
                                    print(error)
                                }
                            }
                            
                        }
                    }
                    Spacer()
            }
        
            
        }// end ScrollView
        .onAppear {
            if let url = URL(string:contest.video_url!) {
                explainerVidPlayer = AVPlayer(url: url)
            } else {
                explainerVidPlayer = AVPlayer()
            }
            
            
        }
        
        VStack {
            Spacer()
            
            VStack {
                // Makes button stack full width for bg gradient
                HStack {
                    Spacer()
                  }.fullScreenCover(isPresented: $isSubmitPresented) {
                      SubmitEntryView(entryUrlString: userState.entryURLString!, userId: String(userState.userModel.user_id))
                  }
                
                if contest.status == "OPEN" || contest.status == "OPENACTIVE" {
                    Button(action: {
                        userState.contestToEnterChosen = true
                        userState.contestToEnter = contest
                        if userState.entryCaptured {
                            isSubmitPresented = true
                        } else {
                            viewRouter.currentPage = .capture
                        }
                    }) {
                        Text("Enter")
                            .frame(minWidth: 0, maxWidth: 300)
                            .font(Font.h5)
                            .foregroundColor(.black)
                    }.frame(width:300).buttonStyle(YellowWideButton()).padding(.top)
                        
                }
                
                if contest.status == "ACTIVE" || contest.status == "OPENACTIVE" {
                    Button(action: {
                        userState.contestToVoteOn = contest
                        presentationMode.wrappedValue.dismiss()
                        viewRouter.currentPage = .vote
                    }) {
                        HStack {
                            Text("Vote")
                                .frame(minWidth: 0, maxWidth: 300)
                                .font(Font.h5)
                                .foregroundColor(.black)
                                .padding(.leading)
                            
                            Image("Shout")
                                .frame(width: 20, height: 25, alignment: .trailing)
                        }
                    }.frame(width:300).buttonStyle(YellowWideButton()).padding(.top)
                }
            }.background( LinearGradient(gradient: Gradient(colors: [.clear, .gray]), startPoint: .top, endPoint: .bottom) )
        }
    }
}
    
    
    struct ContestDetailPlayer : UIViewControllerRepresentable {
        
        var player : AVPlayer
        let controller = AVPlayerViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ContestDetailPlayer>) -> AVPlayerViewController{
            controller.player = player
            //let view = AVPlayerViewController()
            //view.player = player
    //            controller.showsPlaybackControls = false
            controller.videoGravity = .resizeAspectFill
            
            self.addPeriodicTimeObserver()
            
            return controller
        }
        
        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
                uiViewController.player = player
        }
        
        func addPeriodicTimeObserver() {
                self.controller.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (currentTime) in
                    if let endTime = self.controller.player?.currentItem?.duration {
                        if currentTime == endTime {
                            // Reset the player
                            self.controller.player = player
                            self.addPeriodicTimeObserver()
                        }
                    }
                })
            }
    }
        
}

struct ContestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContestDetailView(contest: AppConstants.defaultContest)
    }
}

func getFormattedDate(dateString: String, format: String = "LLLL dd") -> String {
    let formatter1 = DateFormatter()
//    formatter1.dateStyle = .medium
//    formatter1.timeStyle = .short
    formatter1.dateFormat = format
    let formatterLong = DateFormatter()
    formatterLong.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    let formatterShort = DateFormatter()
    formatterShort.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let theDate = formatterLong.date(from: dateString) {
        return formatter1.string(from: theDate )
    } else if let theDate = formatterShort.date(from: dateString) {
        return formatter1.string(from: theDate )
    } else {
        return "Unreadable date format"
    }
    
}

extension URL {
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Swift 5.3
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)

            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
}


func getThumbnailImageFromVideoUrl(url: URL) async throws -> UIImage {
    
    let asset = AVAsset(url: url)
    let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    avAssetImageGenerator.appliesPreferredTrackTransform = true
    let thumnailTime = CMTimeMake(value: 2, timescale: 1)
    do {
        let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
        let thumbImage = UIImage(cgImage: cgThumbImage)
        return thumbImage
    } catch {
        print(error.localizedDescription)
        throw error
    }
}
