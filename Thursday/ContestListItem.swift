//
//  ContestListItemView.swift
//  Thursday
//
//  Created by Scott Begin on 11/6/22.
//

import SwiftUI
import NukeUI

struct ContestListItem: View {
    
    @State var contest : Contest
    var contestListItemType: ContestListItemType
    
    var body: some View {
        
            ZStack {
                HStack {
                    LazyImage(source: contest.image_url, resizingMode: .aspectFit)
                        .frame(width: 100, height: 100, alignment: .topLeading)
                    
                    
                    VStack(alignment: .leading) {
                        Text(contest.name.trimmingCharacters(in: .whitespacesAndNewlines)).font(Font.h5).foregroundColor(Color.black).lineLimit(2)//.bold()
                        Text(String(contest.contestant_count)+" Contestants").font(.subheadline).foregroundColor(Color.black)
                        
                        Spacer()
                        
                        HStack(alignment: .bottom){
                            if (contest.status == "OPENACTIVE" || contest.status == "OPEN") {
                                Chip(titleKey: "ENTER", backgroundColor: Color.neutral50, textColor: Color.neutral800)
                            }
                            if (contest.status == "OPENACTIVE" || contest.status == "ACTIVE") {
                                Chip(titleKey: "VOTE", backgroundColor: Color.neutral50, textColor: Color.neutral800)
                            }
                            Chip(titleKey: contest.prize, backgroundColor: Color.neutral50, textColor: Color.neutral800)
                            Spacer()
                        }
                        .frame(width: 200)
                        
                    }
                    Spacer()
                }
                
                Spacer()
                HStack() {
                    Spacer()
                    Image(systemName: "ellipsis")
                        .rotationEffect(Angle(degrees: 90))
                }
            }
        }
    }

enum ContestListItemType {
    case list
    case tile
}

struct ContestListItem_Previews: PreviewProvider {
    static var previews: some View {
        
        ContestListItem(contest: AppConstants.defaultContest, contestListItemType: .list)
    }
}
