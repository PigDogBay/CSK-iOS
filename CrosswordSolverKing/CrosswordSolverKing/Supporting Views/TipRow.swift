//
//  TipRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct TipRow: View {
    let tip : Tip
    var body: some View {
        HStack {
            Image(systemName: "lightbulb")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color.yellow)
                .padding(8)
            VStack(alignment: .leading){
                Text(tip.title).font(.title)
                Text(tip.description).font(.footnote)
            }
            Spacer()
        }
    }
}

struct TipRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TipRow(tip: TipData[0])
            TipRow(tip: TipData[1])
            TipRow(tip: TipData[2])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
