//
//  TipRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct TipRow: View {
    let title : String
    let description : String
    var body: some View {
        HStack {
            Image(systemName: "lightbulb")
                .font(Font.system(.largeTitle).bold())
                .padding(8)
            VStack(alignment: .leading){
                Text(title).font(.title)
                Text(description).font(.footnote)
            }
            Spacer()
        }
    }
}

struct TipRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TipRow(title: "Cr?sswords", description: "Press space for unknown letters")
            TipRow(title: "Anagrams",description: "Enter your letters")
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
