//
//  Vote.swift
//  Thursday
//
//  Created by Scott Begin on 1/3/23.
//

import Foundation


struct Vote: Codable {
    var vote_id: Int?
    var owner_id: Int
    var chosen: Int
    var declined: Int        
}

extension Vote: Identifiable {
  var id: Int { vote_id! }
}
