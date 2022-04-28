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
    @Published var bestStories: [Story] = []
    
    private var api: API
    private var subs = Set<AnyCancellable>()
    private var allStoryIds: [Int] = []
    private var maxStories = 20
    
    //MARK: - Lifecycle
    init() {
        api = API()

        api.bestStoriesIDs()
            .sink { _ in
                self.getInitialStories()
            } receiveValue: { ids in
                self.allStoryIds = ids
            }
            .store(in: &subs)

    }
    
    
    //MARK: - Methods
    public func getInitialStories(){
        let range = getAvailableRange()
        api.bestStories(in: range)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { stories in
                self.bestStories = stories
            }
            .store(in: &subs)
    }
    
    private func getAvailableRange() -> [Int]{
        guard !allStoryIds.isEmpty else {
            return []
        }
        
        if bestStories.isEmpty {
            return Array(allStoryIds.prefix(maxStories))
        } else {
          return []
        }
    }
}
