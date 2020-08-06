//
//  Coordinator.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

class Coordinator : ObservableObject {
    let model : Model
    let ratings : Ratings
    let mainVM : MainViewModel
    
    init(){
        model = Model()
        ratings = Ratings(appId: Strings.appId)
        mainVM = MainViewModel(model: model)
    }
}
