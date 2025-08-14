//
//  Chip.swift
//  Thursday
//
//  Created by Scott Begin on 11/6/22.
//

import SwiftUI

struct Chip: View {
    
    let titleKey: String //text or localisation value
    var backgroundColor: Color
    var textColor: Color
    
    var body: some View {
        HStack {
            Text(titleKey).font(.footnote).lineLimit(1).foregroundColor(textColor)
        }.padding(.all, 8)
//        .foregroundColor(.blue)
        .background(backgroundColor)
        .cornerRadius(12)
        .frame(height: 40, alignment: .leading)
        
//        .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.blue, lineWidth: 1.5)
//        )
    }
}
