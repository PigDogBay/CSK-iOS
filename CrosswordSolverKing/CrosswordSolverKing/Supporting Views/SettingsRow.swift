//
//  SettingsRow.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 21/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import SwiftUtils

struct SettingsRow: View {
    var body: some View {
        Button(action: mpdbShowSettings){
            HStack {
                Image(systemName: "gear")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.green)
                    .padding(8)
                VStack(alignment: .leading){
                    Text("Settings").font(.title)
                    Text("Change the word list and more").font(.footnote)
                }
                Spacer()
            }
        }
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow()
    }
}
