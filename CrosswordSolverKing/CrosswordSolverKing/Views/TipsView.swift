//
//  TipsView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct TipsView: View {
    @EnvironmentObject var model : Model
    @ObservedObject var aboutVM : AboutViewModel

    var body: some View {
        List {
            ForEach(tipsData) { tip in
                LinkedTipRow(viewModel: HelpViewModel(tip: tip, model: self.model))
            }
            NavigationLink(destination: FilterHelpView()){
                FilterRow()
            }
            NavigationLink(destination: AboutView(viewModel: aboutVM)){
                AboutRow()
            }
            SettingsRow()
            FeedbackRow()
            RateRow()
            TellFriendRow()
        }.gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }
}

/*
 LinkedTipRow binds the TipRow and NavigationLink to showTip
 which allows TipRow to pop the view when the show me button is pressed.
 */
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
        TipsView(aboutVM: AboutViewModel()).environmentObject(MainViewModel())
    }
}
