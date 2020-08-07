//
//  DefintionHelpView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 05/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct HelpSectionView: View {
    let title : String
    let icon : String
    let description : String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.blue)
                    .padding(.trailing,8)
                Text(title)
                    .font(.headline)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
            }

            Text(description)
                .font(.body)
        }
        .padding(8)
    }
}

struct DefintionHelpView: View {
    @EnvironmentObject var coordinator : Coordinator
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "info.circle")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.green)
                    .padding()
                Text("Definitions")
                    .font(.largeTitle)
                Spacer()
            }
            HelpSectionView(title: "Look up", icon: "book", description: "Tap on a result to look up it's defintion on the web.")
            HelpSectionView(title: "Speak", icon: "speaker.3", description: "Tap on the speaker icon for the app to say the word.")
            HelpSectionView(title: "Copy", icon: "doc.on.doc", description: "Tap on the copy icon to copy the word onto the clipboard. You can then paste the word into other apps.")
            HelpSectionView(title: "Long Press", icon: "hand.point.right", description: "Touch and hold a word to bring up a menu to choose which website to look up the word.")
            HelpSectionView(title: "Settings", icon: "gear", description: "Change the default look up website in the settings")
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
        .onAppear(perform: {self.coordinator.onAppear(screen: .DefinitionHelp)})
        .onDisappear(perform: {self.coordinator.onDisappear(screen: .DefinitionHelp)})
    }
    
}

struct DefintionHelpView_Previews: PreviewProvider {
    static var previews: some View {
        DefintionHelpView()
    }
}
