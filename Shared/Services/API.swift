//
//  API.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import Foundation
import Combine

struct API {
    var task: AnyCancellable?
    
    enum Endpoints {
        static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0")!
        
        case item(id: Int)
        case bestStories
        
        var url: URL {
            switch self {
            case .item(let id):
                return Endpoints.baseURL.appendingPathComponent("item/\(id).json")
            case .bestStories:
                return Endpoints.baseURL.appendingPathComponent("beststories.json")
            }
        }
    }
    
    private let decoder = JSONDecoder()
    private let privateQueue = DispatchQueue(label: "HackerNewsAPI", qos: .default, attributes: .concurrent)
    
    private func fetchStoryById(id: Int) -> AnyPublisher<Story, Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoints.item(id: id).url)
            .receive(on: privateQueue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func fetchStoriesWithIds(ids: [Int]) -> AnyPublisher<Story, Error> {
        let publisherForFirstId = fetchStoryById(id: ids.first!)
        let remainingIds = Array(ids.dropFirst())
        
        return remainingIds.reduce(publisherForFirstId) { results, nextId in
            return results
                .merge(with: fetchStoryById(id: nextId))
                .eraseToAnyPublisher()
        }
    }
    
    public func bestStories(in range: [Int]) -> AnyPublisher<[Story], Error> {
        range
            .publisher
            .collect()
            .filter({!$0.isEmpty})
            .flatMap({ ids in
                return self.fetchStoriesWithIds(ids: ids)
            })
            .removeDuplicates()
            .scan([]) { stories, story -> [Story] in
                return stories + [story]
            }
            .map({$0.sorted()})
            .eraseToAnyPublisher()
    }
    
    public func bestStoriesIDs() -> AnyPublisher<[Int], Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoints.bestStories.url)
            .map(\.data)
            .receive(on: privateQueue)
            .decode(type: [Int].self, decoder: decoder)
            .filter({!$0.isEmpty})
            .eraseToAnyPublisher()
    }
}
