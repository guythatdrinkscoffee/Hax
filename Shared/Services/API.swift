//
//  API.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import Foundation
import Combine

enum Endpoints {
    static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0")!
    
    case item(id: Int)
    case bestStories
    case topStories
    case newStories
    
    var url: URL {
        switch self {
        case .item(let id):
            return Endpoints.baseURL.appendingPathComponent("item/\(id).json")
        case .bestStories:
            return Endpoints.baseURL.appendingPathComponent("beststories.json")
        case .topStories:
            return Endpoints.baseURL.appendingPathComponent("topstories.json")
        case .newStories:
            return Endpoints.baseURL.appendingPathComponent("newstories.json")
        }
    }
}

struct API {
    var task: AnyCancellable?

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
    
    public func fetchStories(in range: [Int]) -> AnyPublisher<[Story], Error> {
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
    
    public func storyIdsForCategory(category: HaxDestination) -> AnyPublisher<[Int], Error> {
        let endpoint: Endpoints
        
        switch category {
        case .topStories:
            endpoint = Endpoints.topStories
        case .bestStories:
            endpoint = Endpoints.bestStories
        
        }
        
        return  URLSession.shared
            .dataTaskPublisher(for:  endpoint.url)
            .map(\.data)
            .receive(on: privateQueue)
            .decode(type: [Int].self, decoder: decoder)
            .filter({!$0.isEmpty})
            .eraseToAnyPublisher()
    }
    
    private func fetchCommentByID(id: Int) -> AnyPublisher<Comment, Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoints.item(id: id).url)
            .receive(on: privateQueue)
            .map(\.data)
            .decode(type: Comment.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func fetchComments(ids: [Int]) -> AnyPublisher<Comment, Error>{
        let publisherForFirstComment = fetchCommentByID(id: ids.first!)
        let remainingComments = Array(ids.dropFirst())
        
        return remainingComments.reduce(publisherForFirstComment) { results, nextCommentId in
            results
                .merge(with: fetchCommentByID(id: nextCommentId))
                .eraseToAnyPublisher()
        }
    }
    
    public func fetchComments(with ids: [Int]) -> AnyPublisher<[Comment],Error>{
        ids.publisher
            .collect()
            .filter({!$0.isEmpty})
            .flatMap { ids in
                return self.fetchComments(ids: ids)
            }
            .scan([]) { results, comment -> [Comment] in
                if comment.author.isEmpty || comment.text.isEmpty {
                    return results
                }
                
                return results + [comment]
            }
            .map({ $0.sorted() })
            .eraseToAnyPublisher()
    }
}
