//
//  HaxViewer.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import SwiftUI

struct HaxViewer: View {
    @ObservedObject var bestStoriesViewModel = BestStoriesViewModel()
    @ObservedObject var topStoriesViewModel = TopStoriesViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                StoriesView(currentState: $topStoriesViewModel.currentState, stories: topStoriesViewModel.stories)
                    .navigationTitle("Top Stories")
            }
            .tabItem {
                Label("Top", systemImage: "star")
            }
            .tag(HaxDestination.topStories)
            
            
            NavigationView {
                StoriesView(currentState: $bestStoriesViewModel.currentState, stories: bestStoriesViewModel.stories)
                    .navigationTitle("Best Stories")
            }
            .tabItem {
                Label("Best", systemImage: "newspaper")
            }
            .tag(HaxDestination.bestStories)
        }
    }
}

struct HaxViewer_Previews: PreviewProvider {
    static var previews: some View {
        HaxViewer()
    }
}
