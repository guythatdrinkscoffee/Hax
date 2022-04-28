//
//  HaxViewer.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import SwiftUI

enum HaxDestination: CaseIterable{
    case topStories
    case bestStories
}

struct HaxViewer: View {
    @State var selection: HaxDestination? = .bestStories
    @ObservedObject var bestStoriesViewModel = BestStoriesViewModel()
    @ObservedObject var topStoriesViewModel = TopStoriesViewModel()
    
    var sideBar: some View {
        List(selection: $selection) {
            Section("STORIES"){
                NavigationLink(
                    destination: StoriesView(currentState: $topStoriesViewModel.currentState, stories: topStoriesViewModel.stories),
                    tag: HaxDestination.topStories,
                    selection: $selection
                ){
                    Label("Top Stories", systemImage: "star")
                }
             
                NavigationLink(
                    destination: StoriesView(currentState: $bestStoriesViewModel.currentState, stories: bestStoriesViewModel.stories),
                    tag: HaxDestination.bestStories,
                    selection: $selection) {
                        Label("Best Stories", systemImage: "newspaper")
                    }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            sideBar
            Text("Select a Category")
            Text("Select a Story")
        }
        .frame(
          minWidth: 700,
          idealWidth: 1000,
          maxWidth: .infinity,
          minHeight: 400,
          idealHeight: 800,
          maxHeight: .infinity)
        .navigationTitle("Hax")
    }
}

struct HaxViewer_Previews: PreviewProvider {
    static var previews: some View {
        HaxViewer()
    }
}
