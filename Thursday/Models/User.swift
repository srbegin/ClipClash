//
//  User.swift
//  Thursday
//
//  Created by Scott Begin on 10/20/22.
//

import Foundation
import SwiftUI

struct User: Decodable {
    var id: Int
    var username: String
    var first_name: String
    var last_name: String
    var last_contest_viewed: String?
    var profile_pic: String?
    var credits: Int = 0
}

final class UserState: ObservableObject {
    @Published var userModel: User
    @Published var contestToEnterChosen: Bool
    @Published var entryCaptured: Bool
    @Published var contestToEnter: Contest?
    @Published var contestToVoteOn: Contest?
    @Published var entryURLString: String?
    @Published var entryFileName: String?
    @Published var entryThumbnail: Image?
    @Published var entryCaption: String?
    @Published var contestBrowsingStatus: ContestStatus?
    @Published var token: String
    
    init(user: User, token: String, contestToVoteOn: Contest, contestToEnter: Contest, contestBrowsingStatus: ContestStatus)  {
        self.userModel = user
        self.token = token
        self.contestToVoteOn = contestToVoteOn
        self.contestToEnter = contestToEnter
        self.contestBrowsingStatus = contestBrowsingStatus
        self.contestToEnterChosen = false
        self.entryCaptured = false
    }
    
    func clearEntryIntent() {
        self.contestToEnterChosen = false
        self.entryCaptured = false
        self.entryFileName = ""
        self.entryURLString = ""
        self.entryCaption = ""
        self.entryThumbnail = nil
        self.contestToEnter = nil
    }
    
//    static func logOut () {
//        print("logout called")
//        self.init(user: AppConstants.defaultUser, token: "", contestToVoteOn: AppConstants.defaultContest,
//                  contestToEnter: AppConstants.defaultContest, contestBrowsingStatus: .active)
//    }
    
   
    
}

//extension UserState {
//
//  static var loggedOut: Self {
//    return UserState(
//      user: AppConstants.defaultUser,
//      token: "",
//      contestToVoteOn: AppConstants.defaultContest,
//      contestToEnter: AppConstants.defaultContest,
//      contestBrowsingStatus: .active
//    ) as! Self
//  }
//}



extension User: Identifiable {
  var user_id: Int { id }
}
