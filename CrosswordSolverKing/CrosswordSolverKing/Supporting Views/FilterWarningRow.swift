//
//  FilterWarningRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 18/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct FilterWarningRow: View {
    let filterCount : Int
    @State private var isJiggling = true
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color.red)
                .rotationEffect(.degrees(isJiggling ? -15: 15))
                //                .scaleEffect(isJiggling ? 0.75 : 1.25)
                .animation(Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true))
                .padding(8)
            VStack(alignment: .leading){
                Text("Active Filters").font(.title)
                if filterCount == 1 {
                    Text("You have one filter active").font(.footnote)
                } else {
                    Text("\(self.filterCount) filters are active").font(.footnote)
                }
            }
            Spacer()
        }.onAppear(){
            self.isJiggling.toggle()
        }
    }
}

struct FilterWarningRow_Previews: PreviewProvider {
    static var previews: some View {
        FilterWarningRow(filterCount: 2).previewLayout(.fixed(width: 300, height: 70))

    }
}
