//
//  MediaItemListView.swift
//  Thursday
//
//  Created by Scott Begin on 10/6/22.
//

//import SwiftUI
//
//struct MediaItemListView: View {
//    
//    @EnvironmentObject var network: Network
//    
//    @Binding var currentUserId: String
//    
//    
//    var body: some View {
//        
//        ScrollView {
//            
//            VStack(alignment: .leading) {
//                ForEach(network.mediaItems) { mediaitem in
//                    HStack(alignment:.top) {
//                        Text("\(mediaitem.id!)")
//
//                        VStack(alignment: .leading) {
//                            Text(mediaitem.name)
//                                .bold()
//                        }
//                    }
//                    .frame(width: 300, alignment: .leading)
//                    .padding()
//                    .background(Color(#colorLiteral(red: 0.6667672396, green: 0.7527905703, blue: 1, alpha: 0.2662717301)))
//                    .cornerRadius(20)
//                }
//            }
//                }
//                .onAppear {
//                    network.getMediaItemsByOwner(ownerId: $currentUserId.wrappedValue)
//                }
//        
//    }
//}
//
//struct MediaItemListView_Previews: PreviewProvider {
//    @State static var user: String = "1"
//    static var previews: some View {
//        
//        MediaItemListView(currentUserId: $user)
//    }
//}
