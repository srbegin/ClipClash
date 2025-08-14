//
//  ImageOnCircle.swift
//  Thursday
//
//  Created by Scott Begin on 12/17/22.
//

import SwiftUI


struct ImageOnCircle: View {
    
    var icon: String = ""
    var asset: String = ""
    let radius: CGFloat
    var circleColor: Color
    var iconColor: Color = Color.black // Remove this for an image in your assets folder.
    var borderColor = Color.black
    var borderWidth = 1.0
    var imageScale = 1.0
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(borderColor, lineWidth: borderWidth)
                .background(Circle().fill(circleColor))
                .frame(width: radius * 2, height: radius * 2)
                           
            // Use this implementation for an SF Symbol
            if (icon != "") {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: squareSide * imageScale, height: squareSide * imageScale)
                    .foregroundColor(iconColor)
                    
            } else if (asset != ""){
                Image(asset)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: squareSide * imageScale, height: squareSide * imageScale)
            }
        }
    }
}
    

struct ImageOnCircle_Previews: PreviewProvider {
    static var previews: some View {
        ImageOnCircle(radius: 1.0, circleColor: .black)
    }
}
