//
//  Entry.swift
//  Thursday
//
//  Created by Scott Begin on 10/5/22.
//

import Foundation

struct Entry: Codable {
    var entry_id: Int?
    var media_item: MediaItem
    var created_at: String?
    var updated_at: String?
    var score: Int?
    var contest_id: Int
    
}

extension Entry: Identifiable {
  var id: Int { entry_id! }
}
