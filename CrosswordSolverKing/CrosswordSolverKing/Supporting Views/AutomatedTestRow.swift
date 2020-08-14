//
//  AutomatedTestRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 14/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct AutomatedTestRow: View {
    @EnvironmentObject var coordinator : Coordinator
    var body: some View {
        Button(action: {AutoTest.start(coordinator: self.coordinator)}){
            HStack {
                Image(systemName: "wand.and.stars")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.gray)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("Auto Test").font(.title)
                    Text("Run the automated tests").font(.footnote)
                }
                Spacer()
            }
        }
    }
}

struct AutomatedTestRow_Previews: PreviewProvider {
    static var previews: some View {
        AutomatedTestRow()
    }
}
