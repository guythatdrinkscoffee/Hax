//
//  HaxViewer.swift
//  Hax
//
//  Created by J Manuel Zaragoza on 4/27/22.
//

import SwiftUI

enum HaxDestination: CaseIterable{
    case bestStories
}

struct HaxViewer: View {
    @State var destinationSelection: HaxDestination? = .bestStories
    
    var sideBar: some View {
        List(selection: $destinationSelection) {
            NavigationLink(
                destination: BestStoriesView(), tag: HaxDestination.bestStories, selection: $destinationSelection) {
                    Label("Best Stories", systemImage: "newspaper")
                }
        }
    }
    
    var body: some View {
        NavigationView {
            sideBar
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
