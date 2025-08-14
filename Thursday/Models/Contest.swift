//
//  Contest.swift
//  Thursday
//
//  Created by Scott Begin on 10/5/22.
//

import Foundation


struct Contest: Decodable {
    var contest_id: Int
    var status: String
    var contestant_count: Int
    var name: String
    var owner_id: Int
    var created_at: String
    var updated_at: String
    var image_url: String?
    var video_url: String? 
    var submit_start: String
    var submit_end: String
    var voting_start: String
    var voting_end: String
    var description: String = ""
    var prize: String = ""
    var min_entries: Int
    var max_entries: Int
    var is_public: Bool?
}

extension Contest: Identifiable {
  var id: Int? { contest_id }
}
