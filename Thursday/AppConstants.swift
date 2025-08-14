//
//  AppConstants.swift
//  Thursday
//
//  Created by Scott Begin on 11/15/22.
//

import Foundation

struct AppConstants {
    static let defaultScreen = Page.contests
    
    static let defaultProfileView = ProfileView.drafts
    
    static let anythingGoesContestId = 11
    
    static let defaultVotingContest = String(anythingGoesContestId)
    
    static let defaultUser = User(id: 1, username: "defaultUser", first_name: "Default", last_name: "User", last_contest_viewed: "1", profile_pic: "", credits: 0)
    
    static let defaultContest = Contest(contest_id: 11, status: "", contestant_count: 0, name: "Anything Goes!!", owner_id: 1, created_at: "", updated_at: "", submit_start: "", submit_end: "", voting_start: "", voting_end: "", min_entries: 2, max_entries: 10)
    
    static let defaultMediaItem = MediaItem(media_item_id: 1, is_entry: "False", owner_id: 1, video_url: "", thumbnail_url: "", filename_key: "")
    
    static let initialUserState = UserState(user: defaultUser, token: UserDefaults.standard.string(forKey: "userToken") ?? "", contestToVoteOn: defaultContest, contestToEnter: defaultContest, contestBrowsingStatus: ContestStatus.active)
    
    static let amazonS3Url = "https://thursday-content.s3.amazonaws.com/"
    
    static let amazonS3BucketName = "thursday-content"
    
    static let amazonEBUrl = "http://ThursDev221003-2.eba-a2tkz4dp.us-east-1.elasticbeanstalk.com/"
    
    
//    static let loggedOutUserState = UserState(user: defaultUser, token: "", contestToVoteOn: defaultContest,
//                                            contestToEnter: defaultContest, contestBrowsingStatus: ContestStatus.active)
    
    
//    struct ContestStatus {
//        static let all = "ALL"
//    }
    
}
