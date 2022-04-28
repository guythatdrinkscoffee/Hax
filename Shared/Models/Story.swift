//
//  Story.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import Foundation

struct Story: Codable, Comparable, Hashable {
    let author: String
    let id: Int
    let comments: [Int]
    let title: String
    let score: Int
    let time: TimeInterval
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, title, time, url, score
        case author = "by"
        case comments = "kids"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        author = try container.decode(String.self, forKey: .author)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        time = try container.decode(TimeInterval.self, forKey: .time)
        score = try container.decode(Int.self, forKey: .score)
        comments = try container.decode([Int].self, forKey: .comments)
        url = URL(string: try container.decodeIfPresent(String.self, forKey: .url) ?? " ")
    }
    
    public static func < (lhs: Story, rhs: Story) -> Bool {
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



