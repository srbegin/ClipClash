//
//  NetworkController.swift
//  Thursday
//
//  Created by Scott Begin on 12/11/22.
//

import Foundation
import SwiftUI


class NetworkController: ObservableObject {
    
    @Published var contests: [Contest] = []
    @Published var entries: [Entry] = []
    @Published var entryPair: [Entry] = []
    @Published var mediaItems: [MediaItem] = []
    
//    var network = Network()
    
}
