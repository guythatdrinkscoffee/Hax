//
//  BestStoriesViewModel.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import Foundation
import Combine

class BestStoriesViewModel: ObservableObject {
    //MARK: - Properties
    @Published var stories: [Story] = []
    @Published var currentState: LoadingState = .loading

    private var api: API
    private var subs = Set<AnyCancellable>()
    private var allStoryIds: [Int] = []
    private var maxStories = 20
    private var bestStoriesSub: AnyCancellable?
    
    //MARK: - Lifecycle
    init() {
        api = API()
        
        api.storyIdsForCategory(category: .bestStories)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.fetch()
            }, receiveValue: { ids in
                self.allStoryIds = ids
            })
            .store(in: &subs)
        
        $currentState
            .sink { _ in
                
            } receiveValue: { newState in
                if newState == .cancel  {
                    self.cancel()
                }
            }
            .store(in: &subs)

    }

    //MARK: - Methods
    private func getAvailableRange() -> [Int]{
        guard !allStoryIds.isEmpty else {
            return []
        }
        
        if stories.isEmpty {
            return Array(allStoryIds.prefix(maxStories))
        } else {
          return []
        }
    }
}

extension BestStoriesViewModel: StoriesFetcher {
    func fetch() {
        let range = getAvailableRange()
        
        bestStoriesSub =  api.fetchStories(in: range)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.currentState = .completed
            } receiveValue: { stories in
                self.stories = stories
            }

    }
    
    func cancel() {
        if let bestStoriesSub = bestStoriesSub {
            if currentState == .loading {
                bestStoriesSub.cancel()
            }
        }
    }
}

protocol StoriesFetcher: AnyObject {
    func fetch()
    func cancel()
}
