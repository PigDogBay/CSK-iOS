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
    let model : Model
    
    var showMePressed = false
    
    init(tip : Tip, model : Model){
        self.tip = tip
        self.model = model
    }
    func onDisappear() {
        //TODO if main screen not showing search will fail
        //maybe create a showMe Publisher that waits until the main screen is visible and then searches
        if showMePressed {
            model.query = tip.showMe
            showMePressed = false
        }
    }
    
    func showMe(){
        showTip = false
        showMePressed = true
    }

}
