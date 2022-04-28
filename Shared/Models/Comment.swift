//
//  Comment.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import Foundation

struct Comment: Codable, Comparable{
    let author: String
    let id: Int
    let comments: [Int]
    let text: String
    let time: TimeInterval
    let type: String
    
    enum CodingKeys: String, CodingKey{
        case id,text, time, type
        case author = "by"
        case comments = "kids"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        id = try container.decode(Int.self, forKey: .id)
        comments = try container.decodeIfPresent([Int].self, forKey: .comments) ?? []
        text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        time = try container.decode(TimeInterval.self, forKey: .time)
        type = try container.decode(String.self, forKey: .type)
    }
    
    public static func < (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.time > rhs.time
    }
    
    var relativeTimeText: String {
        let date = Date(timeIntervalSince1970: time)
        
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.current
        formatter.calendar = Calendar.current
        formatter.dateTimeStyle = .numeric
        
        return formatter.localizedString(for: date, relativeTo: Date())
    }

}
