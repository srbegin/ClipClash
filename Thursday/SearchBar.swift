//
//  SearchBar.swift
//  Thursday
//
//  Created by Scott Begin on 10/7/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var searching: Bool
    
     var body: some View {
         ZStack {
             Rectangle()
                 .foregroundColor(Color.neutral50)
             HStack {
                 Image(systemName: "magnifyingglass")
                 TextField("Search ..", text: $searchText) { startedEditing in
                     if startedEditing {
                         withAnimation {
                             searching = true
                         }
                     }
                 } onCommit: {
                     withAnimation {
                         searching = false
                     }
                 }
                 HStack {
                     if searching {
                         Button(action: {
                             self.searchText = ""
                             searching = false
                         }){
                             Image(systemName: "multiply.circle.fill")
                                 .foregroundColor(.gray)
                                 .padding(.trailing, 8)
                         }
                     }
                 }
             }
             .foregroundColor(.gray)
             .padding(.leading, 8)
             
         }
         .frame(height: 40)
         .cornerRadius(13)
         .padding()
     }
 }

struct SearchBar_Previews: PreviewProvider {
    @State static var searchText = "blah blah"
    @State static var searching = false
    
    static var previews: some View {
        SearchBar(searchText: $searchText, searching: $searching)
    }
}
