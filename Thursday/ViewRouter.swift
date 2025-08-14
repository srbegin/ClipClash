//
//  ViewRouter.swift
//  Thursday
//
//  Created by Scott Begin on 10/18/22.
//


import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page
    @Published var previousPage: Page
    @Published var currentProfileView: ProfileView

    init(currentPage: Page, previousPage: Page, currentProfileView: ProfileView)  {
        self.currentPage = currentPage
        self.previousPage = previousPage
        self.currentProfileView = currentProfileView
        
        }
    
}

enum Page {
    case vote
    case contests
    case capture
    case wallet
    case user
}

enum ProfileView {
    case none
    case entries
    case drafts
    case favorites
    case inbox
}

enum ContestStatus: String {
    case all
    case future
    case open
    case active
    case past
}
