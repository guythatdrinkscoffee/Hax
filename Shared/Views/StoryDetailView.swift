//
//  StoryDetailView.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import SwiftUI

struct StoryDetailView: View {
    @ObservedObject var storyViewModel = StoryViewModel()
    
    var story: Story
    
    var body: some View {
        VStack {
            #if os(iOS)
            HStack{
               Spacer()
               Label(story.relativeTimeText, systemImage: "clock.arrow.circlepath")
                    .padding(.trailing, 5)
            }
            #endif
            
            Text(story.title)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title2)
                .padding()
            HStack {
                Spacer()
                #if os(macOS)
                  StoryInfo(story: story, showUrl: true, showTime: true)
                #else
                  StoryInfo(story: story, showUrl: false, showTime: false)
                #endif
                Spacer()
            }
            
            Divider()
            
            if storyViewModel.currentState == .loading {
                VStack{
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(maxHeight: .infinity)
            } else {
                CommentsView(comments: storyViewModel.comments)
            }
            
        }
        .background()
        .onAppear {
            storyViewModel.fetchComments(for: story)
        }
        .onDisappear{
            storyViewModel.cancelFetch()
        }
    }
    
}

struct StoryDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        StoryDetailView(story: Story.dummy!)
    }
}

struct CommentsView: View {
    var comments: [Comment]
    
    var body: some View {
        List {
            ForEach(comments, id:\.id) { comment in
                CommentRow(comment: comment)
            }
        }
    }
}

struct CommentRow: View {
    var comment: Comment
    
    var body: some View {
        VStack{
            HStack {
                Text(comment.author)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(comment.relativeTimeText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
            }
            
            Text(comment.text)
                .frame(maxWidth:.infinity, alignment: .leading)
                .padding(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
            
            #if os(macOS)
            Divider()
            #endif
        }
    }
}
