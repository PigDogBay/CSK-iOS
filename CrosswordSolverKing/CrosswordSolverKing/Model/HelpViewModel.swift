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
    
    init(tip : Tip){
        self.tip = tip
    }
    
    func showMe(){
        showTip = false
    }

}
