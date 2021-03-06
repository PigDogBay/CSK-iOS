//
//  TipsView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct TipsView: View {
    @ObservedObject var filters : Filters

    var body: some View {
        List {
            if filters.filterCount>0 {
                NavigationLink(destination: FiltersView(filters: self.filters)){
                    FilterWarningRow(filterCount: filters.filterCount)
                }
            }
            ForEach(tipsData) { tip in
                LinkedTipRow(viewModel: HelpViewModel(tip: tip))
            }
            NavigationLink(destination: FilterHelpView()){
                FilterRow()
            }
            NavigationLink(destination: DefintionHelpView()){
                DefinitionRow()
            }
            NavigationLink(destination: AboutView()){
                AboutRow()
            }
            SettingsRow()
            FeedbackRow()
            RateRow()
            TellFriendRow()
//            AutomatedTestRow()
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
        TipsView(filters: Filters()).environmentObject(Coordinator())
    }
}
