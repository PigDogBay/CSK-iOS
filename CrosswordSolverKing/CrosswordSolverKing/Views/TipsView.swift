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
            ForEach(tipsData) { tip in
                LinkedTipRow(viewModel: HelpViewModel(tip: tip))
            }
        }.gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

struct LinkedTipRow : View {
    @ObservedObject var viewModel : HelpViewModel
    var body : some View {
        NavigationLink(destination: HelpView(viewModel: viewModel), isActive: $viewModel.showTip){
            TipRow(tip: viewModel.tip)
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
