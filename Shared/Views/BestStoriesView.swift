//
//  BestStoriesView.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import SwiftUI

struct BestStoriesView: View {
    @ObservedObject var viewModel  = BestStoriesViewModel()
    
    var body: some View {
        List {
            ForEach(Array(zip(viewModel.bestStories.indices, viewModel.bestStories)), id: \.1) { index , story in
                StoryRow(story: story, index: index+1)
            }
        }
    }
}

struct BestStoriesView_Previews: PreviewProvider {
    
    static var previews: some View {
        BestStoriesView()
            .environmentObject(BestStoriesViewModel())
    }
}

struct StoryRow: View {
    var story: Story
    var index: Int
    
    var body: some View {
        VStack {
            HStack{
                Text("\(index).")
                    .font(.headline)
                Text(story.title)
                    .font(.title3)
                    .minimumScaleFactor(0.5)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
          
            Spacer()
            
            HStack {
                Label("\(story.score)", systemImage: "arrow.up")
                Label("\(story.author)", systemImage: "person.fill")
                Label("\(story.relativeTimeText)", systemImage: "clock.arrow.circlepath")
                Label("\(story.comments.count)", systemImage: "text.bubble")
                
                if let storyURL = story.url {
                    Text("(\(storyURL.host ?? " " ))")
                        .font(.footnote)
                }
                
                Spacer()
            }
            
            Divider()
        }
    }
}
