//
//  HelpViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 21/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation

class HelpViewModel : ObservableObject {
    @Published var showTip = false
    let tip : Tip
    let mainVM : MainViewModel
    
    var showMePressed = false
    
    init(tip : Tip, mainVM : MainViewModel){
        self.tip = tip
        self.mainVM  = mainVM
    }
    func onDisappear() {
        //TODO if main screen not showing search will fail
        //maybe create a showMe Publisher that waits until the main screen is visible and then searches
        if showMePressed {
            mainVM.setQueryFrom(tip: tip.showMe)
            showMePressed = false
        }
    }
    
    func showMe(){
        showTip = false
        showMePressed = true
    }

}
