//
//  BestStoriesView.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import SwiftUI

struct StoriesView: View {
    @State private var selectedStory: Story?
    @Binding var currentState: LoadingState
    
    var stories: [Story]
    
    var body: some View {
        List(selection: $selectedStory) {
            if currentState == .loading {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(maxWidth: .infinity,maxHeight:.infinity, alignment: .center)
            } else {
                ForEach(Array(zip(stories.indices, stories)), id: \.1) { index , story in
                    NavigationLink(
                        destination: StoryDetailView(story: story),
                        tag: story,
                        selection: $selectedStory
                    ) {
                        StoryRow(story: story, index: index + 1)
                    }
                }
            }
        }
        .listStyle(.plain)
        .frame(minWidth:520)
        .navigationTitle(navigationTitle)
        .onDisappear {
            if currentState == .loading {
                currentState = .cancel
            }
        }
    }
    
    var navigationTitle: String {
        if let selectedStory = selectedStory {
            return "\(selectedStory.title)"
        }
        return "Hax - Best Stories"
    }
}

//struct BestStoriesView_Previews: PreviewProvider {
//    @Binding static var state = LoadingState?
//    
//    static var previews: some View {
//        StoriesView(currentState: $state, stories: [])
//    }
//}

struct StoryRow: View {
    var story: Story
    var index: Int
    
    var body: some View {
        VStack {
            HStack{
                Text("\(index).")
                    .foregroundColor(.gray)
                    .font(.headline)
                Text(story.title)
                    .font(.title3)
                    .minimumScaleFactor(0.5)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            Spacer()
            
            HStack{
                if let url = story.url {
                    Link(url.host ?? " ", destination: url)
                }
                Spacer()
            }
            
            HStack{
                StoryInfo(story: story, showUrl: false)
                Spacer()
            }
           
            Divider()
        }
    }
}

struct StoryInfo: View {
    var story: Story
    var showUrl: Bool
    
    var body: some View {
        HStack {
            Label("\(story.score)", systemImage: "arrow.up")
            Label("\(story.author)", systemImage: "person")
            Label("\(story.relativeTimeText)", systemImage: "clock.arrow.circlepath")
            Label("\(story.comments.count) comments", systemImage: "text.bubble")
            
            if showUrl {
                if let storyURL = story.url {
                    Link(storyURL.host ?? " ", destination: storyURL)
                        .onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                }
            }
          
        }
    }
}
