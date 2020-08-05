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
    @State private var speakIconScale : CGFloat = 1
    @State private var copyIconScale : CGFloat = 1
    let match : String
    let formatter : WordFormatter
    
    
    private func speak(){
        mpdbSpeak(text: match)
        speakIconScale = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.speakIconScale = 1
        }
    }
    
    private func copy(){
        UIPasteboard.general.string = match
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        copyIconScale = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.copyIconScale = 1
        }
    }
    
    var body: some View {
        HStack {
            Text(formatter.format(match))
            Spacer()
            Image(systemName: "speaker.3")
                .foregroundColor(Color.blue)
                .padding(.trailing,8)
                .onTapGesture(perform: speak)
                .scaleEffect(speakIconScale)
                .animation(Animation.easeOut.speed(2))
            Image(systemName: "doc.on.doc")
                .foregroundColor(Color.blue)
                .padding(.trailing,8)
                .onTapGesture(perform: copy)
                .scaleEffect(copyIconScale)
                .animation(Animation.linear.speed(4))
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
