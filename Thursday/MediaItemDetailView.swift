//
//  MediaItemDetailView.swift
//  Thursday
//
//  Created by Scott Begin on 11/29/22.
//

import SwiftUI
import AVKit

struct MediaItemDetailView: View {
    
    
    @State var mediaItem: MediaItem
    @State var showingAlert = false
    
    
    @EnvironmentObject var userState: UserState
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack (alignment: .top){
            Color.black.ignoresSafeArea()
            
            CustomPlayerView(player: AVPlayer(url: URL(string: mediaItem.video_url)!))
                .frame(width: UIScreen.screenWidth, height: (UIScreen.screenHeight - (UIScreen.screenHeight/8)))
                .edgesIgnoringSafeArea(.all)

            VStack {
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
                        Text(mediaItem.name).font(Font.h3).foregroundColor(.white).padding(.top)
                        Spacer()
                    }
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Text("Delete").frame(minWidth: 0, maxWidth: 300).font(Font.h5).foregroundColor(.black)
                    }
                    .frame(width:300).buttonStyle(YellowWideButton()).padding(.bottom)
                    .confirmationDialog("Delete this video?", isPresented: $showingAlert, titleVisibility: .visible) {
                        Button("Delete") {
                            Task {
                                var key = mediaItem.filename_key
                                if (key.isEmpty) {
                                    print("Yup empty")
                                    key = mediaItem.video_url.replacingOccurrences(of: AppConstants.amazonS3Url, with: "").replacingOccurrences(of: ".mp4", with: "")
                                }
                                
                                _ = try await Network().deleteMediaItemById(id: mediaItem.id!)
                                try await ServiceHandler().deleteFile(bucket: AppConstants.amazonS3BucketName, key: key+".mp4")
                                try await ServiceHandler().deleteFile(bucket: AppConstants.amazonS3BucketName, key: key+".jpg")
                                
                            }
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.screenHeight/28)
            }
        }
    }
     
}


struct MediaItemDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MediaItemDetailView(mediaItem: AppConstants.defaultMediaItem)
    }
}
