//
//  RateRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct RateRow: View {
    var body: some View {
        Button(action: AboutViewModel().rate){
            HStack {
                Image(systemName: "star")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.red)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("Rate").font(.title)
                    Text("Rate the app on the App Store").font(.footnote)
                }
                Spacer()
            }
        }
    }
}

struct RateRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RateRow()
            RateRow()
            RateRow()
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
