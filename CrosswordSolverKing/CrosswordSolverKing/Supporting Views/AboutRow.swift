//
//  AboutRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 21/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct AboutRow: View {
    var body: some View {
        HStack {
            Image(systemName: "shield.lefthalf.fill")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color.blue)
                .padding(8)
            VStack(alignment: .leading){
                Text("About & Privacy").font(.title)
                Text("Information about the app").font(.footnote)
            }
            Spacer()
        }
    }
}

struct AboutRow_Previews: PreviewProvider {
    static var previews: some View {
        AboutRow()
    }
}
