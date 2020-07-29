//
//  FilterRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 29/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FilterRow: View {
    var body: some View {
        HStack {
            Image(systemName: "lightbulb")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color.yellow)
                .padding(8)
            VStack(alignment: .leading){
                Text("Filters").font(.title)
                Text("Too many matches? Refine your search!").font(.footnote)
            }
            Spacer()
        }
    }
}

struct FilterRow_Previews: PreviewProvider {
    static var previews: some View {
        FilterRow()
    }
}
