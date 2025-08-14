//
//  MediaItem.swift
//  Thursday
//
//  Created by Scott Begin on 10/5/22.
//

import Foundation

struct MediaItem: Codable {
    var media_item_id: Int?
    var is_entry: String?
    var owner_profile_pic: String?
    var owner_username: String?
    var name: String = ""
    var owner_id: Int
    var created_at: String?
    var updated_at: String?
    var video_url: String
    var thumbnail_url: String
    var filename_key: String
}

extension MediaItem: Identifiable {
  var id: Int? { media_item_id }
}
