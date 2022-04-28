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
        formatter.unitsStyle = .abbreviated
        formatter.formattingContext = .listItem
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    static var dummy : Story? {
        let json  = """
            {
              "by" : "dhouston",
              "descendants" : 71,
              "id" : 8863,
              "kids" : [ 8952, 9224, 8917, 8884, 8887, 8943, 8869, 8958, 9005, 9671, 8940, 9067, 8908, 9055, 8865, 8881, 8872, 8873, 8955, 10403, 8903, 8928, 9125, 8998, 8901, 8902, 8907, 8894, 8878, 8870, 8980, 8934, 8876 ],
              "score" : 111,
              "time" : 1175714200,
              "title" : "My YC app: Dropbox - Throw away your USB drive",
              "type" : "story",
              "url" : "http://www.getdropbox.com/u/2/screencast.html"
            }
          """
        
        let data = Data(json.utf8)
        
        do {
            let story =  try JSONDecoder().decode(Story.self, from: data)
            return story
        } catch {
            return nil
        }
    }
}



