//
//  TipsView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct TipsView: View {
    var body: some View {
        List {
            ForEach(TipData) { tip in
                NavigationLink(destination: HelpView()){
                    TipRow(tip: tip)
                }
            }
        }.gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
