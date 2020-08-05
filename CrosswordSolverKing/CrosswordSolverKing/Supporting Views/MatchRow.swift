//
//  MatchRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 05/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct MatchRow: View {
    let match : String
    let formatter : WordFormatter
    
    private func speak(){
        mpdbSpeak(text: match)
    }
    
    private func copy(){
        UIPasteboard.general.string = match
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    var body: some View {
        HStack {
            Text(formatter.format(match))
            Spacer()
            Image(systemName: "speaker.3")
                .foregroundColor(Color.blue)
                .padding(.trailing,8)
                .onTapGesture(perform: speak)
            Image(systemName: "doc.on.doc")
                .foregroundColor(Color.blue)
                .padding(.trailing,8)
                .onTapGesture(perform: copy)
        }.padding(8)
    }
}

struct MatchRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MatchRow(match: "astronomer", formatter: WordFormatter())
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
