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
#if os(macOS)
        .frame(minWidth:520)
#endif
        .listStyle(.plain)
//        .navigationTitle(navigationTitle)
        .onDisappear {
            if currentState == .loading {
                currentState = .cancel
            }
        }
    }
    
    var navigationTitle: String {
    #if os(macOS)
        if let selectedStory = selectedStory {
            return "\(selectedStory.title)"
        }
    #endif
        return ""
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
                    .minimumScaleFactor(0.2)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer()
            
            HStack{
                if let url = story.url {
                    Link(url.host ?? " ", destination: url)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,20)
                    #if os(iOS)
                        .padding([.top,.bottom], 10)
                    #endif
                }
                #if os(macOS)
                Spacer()
                #endif
            }
            
            HStack{
                #if os(macOS)
                StoryInfo(story: story, showUrl: false,showTime: true)
                Spacer()
                #else
                StoryInfo(story: story, showUrl: false, showTime: false)
                #endif
            }
            
            #if os(macOS)
            Divider()
            #endif
        }
    }
}

struct StoryInfo: View {
    var story: Story
    var showUrl: Bool
    var showTime: Bool
    
    var body: some View {
        HStack {
            Label("\(story.score)", systemImage: "arrow.up")
            Label("\(story.author)", systemImage: "person")
            Label("\(story.comments.count)", systemImage: "text.bubble")
            if showTime {
                Label("\(story.relativeTimeText)", systemImage: "clock.arrow.circlepath")
            }
            
            if showUrl {
                if let storyURL = story.url {
                    Link(storyURL.host ?? " ", destination: storyURL)
                        .onHover { inside in
                            #if os(macOS)
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                            #endif
                        }
                }
            }
            
        }
    }
}
