//
//  ProfileMediaGridView.swift
//  Thursday
//
//  Created by Scott Begin on 12/1/22.
//

import SwiftUI
import NukeUI

struct ProfileMediaGridView: View {
    
    @StateObject var network = Network()
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var errorHandling: ErrorHandling
    
//    @State var mediaItems: [MediaItem] = []
    @State var isPresenting: MediaItem? = nil
    @State var currentSelection = ProfileView.entries
    
    @State var userId: Int
    
    
    private let fourColumnGrid = [
        GridItem(.fixed((UIScreen.screenWidth/4)), spacing: 1),
        GridItem(.fixed((UIScreen.screenWidth/4)), spacing: 1),
        GridItem(.fixed((UIScreen.screenWidth/4)), spacing: 1),
        GridItem(.fixed((UIScreen.screenWidth/4)), spacing: 1),
        ]
    
    var body: some View {
            
        VStack(spacing: 0) {
                
                if(self.userId == userState.userModel.user_id) {
                    
                    Picker("", selection: $currentSelection.onChange(statusChange)) {
                        Text("Submitted").font(Font.body2).foregroundColor(.black).padding(.leading).foregroundColor(Color.black).tag(ProfileView.entries)
                        Text("Drafts").font(Font.body2).foregroundColor(.black).padding(.leading).foregroundColor(Color.black).tag(ProfileView.drafts)
                    }.pickerStyle(.segmented)
                }
            
            
            VStack {
                
                ScrollView {

                    LazyVGrid(columns: fourColumnGrid, alignment: .center, spacing: 1) {
                        ForEach(network.mediaItems, id: \.id) { mediaitem in
                            if ((currentSelection == .entries && mediaitem.is_entry == "True") || (currentSelection == .drafts && mediaitem.is_entry == "False")) {
                                LazyImage(source: mediaitem.thumbnail_url, resizingMode: .aspectFill)
                                    .frame(width: UIScreen.screenWidth/4, height: 200)
                                    .onTapGesture {
                                        isPresenting = mediaitem
                                    }
                                }
                        }
                        
                        
                    }
                }.fullScreenCover(item: $isPresenting, onDismiss: {
                    Task {
                        await refreshGrid()
                    }                        
                }, content: {mediaitem in
                    MediaItemDetailView(mediaItem: mediaitem)
                })
                .task {
                    await refreshGrid()
                }
                
                }
        }
            .background(Color.white)
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func statusChange(_ tag: ProfileView) {
        Task {
            await refreshGrid()
        }
    }
    
    func refreshGrid() async {
        Task {
            do {
                try await network.getMediaItemsByOwner(ownerId: String(self.userId))
            } catch {
                print(error)
                self.errorHandling.handle(error: error, context: "ProfileMediaGridView refreshGrid()")
            }
        }
    }
    

}

struct ProfileMediaGridView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMediaGridView(userId: 1)
    }
}
