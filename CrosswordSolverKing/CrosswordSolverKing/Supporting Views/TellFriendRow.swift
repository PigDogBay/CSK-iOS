//
//  TellFriendRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//


import SwiftUI


struct TellFriendRow: View {
    var body: some View {
        HStack {
            Image(systemName: "heart")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color.red)
                .padding(8)
            VStack(alignment: .leading){
                Text("Tell a friend").font(.title)
                Text("Message your friends about the app").font(.footnote)
            }
            Spacer()
        }
    }
}

struct TellFriendRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TellFriendRow()
            TellFriendRow()
            TellFriendRow()
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
