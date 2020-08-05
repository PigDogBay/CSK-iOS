//
//  DefinitionRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 05/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct DefinitionRow : View {
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color.green)
                .padding(8)
            VStack(alignment: .leading){
                Text("Definitions").font(.title)
                Text("Tap on a result to look it up").font(.footnote)
            }
            Spacer()
        }
    }
}

struct DefinitionRow_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionRow()
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
