//
//  StoryViewModel.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import Foundation
import Combine

enum LoadingState {
    case loading
    case completed
    case cancel
}

class StoryViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var currentState: LoadingState = .loading
    
    private var subscriptions = Set<AnyCancellable>()
    private var api: API
    private var commentSub: AnyCancellable?
    
    init(){
        api = API()
    }
    
    public func fetchComments(for story: Story){
        currentState = .loading
        commentSub = api.fetchComments(with: story.comments)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.currentState = .completed
            } receiveValue: { comments in
                self.comments = comments
            }
    }
    
    public func cancelFetch(){
        if let commentSub = commentSub {
            if currentState == .loading {
                commentSub.cancel()
                print("Canceling")
            }
        }
    }
}


