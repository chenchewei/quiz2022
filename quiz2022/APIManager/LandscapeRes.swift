//
//  LandscapeRes.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import Foundation

class LandscapeRes: Codable {
    var results: Result?
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try?  container.decode(Result.self, forKey: .results)
//        try super.init(from: decoder)
    }
    
    class Result: Codable {
        let content: [Contents]
    }
    
    class Contents: Codable {
        let lat: Double
        let lng: Double
        let name: String
        let vicinity: String
        let photo: String
        let landscape: [String]
        let star: Int
    }
}
