//
//  Coordinator.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

enum AppScreens {
    case Main, About, Filter
}

///Deals with interactions between views and holds shared observed variables
class Coordinator : ObservableObject {
    let model : Model
    let ratings : Ratings
    let mainVM : MainViewModel
    let settings : Settings

    @Published var showMeRelevantAds = true
    @Published var isAdReloadRequired = false

    init(){
        model = Model()
        ratings = Ratings(appId: Strings.appId)
        mainVM = MainViewModel(model: model)
        settings = Settings()
        showMeRelevantAds = !settings.useNonPersonalizedAds
    }
    
    func onAppear(screen : AppScreens){
        
    }
    
    func onDisappear(screen : AppScreens){
        switch screen {
        case .Main:
            break
        case .About:
            aboutExited()
        case .Filter:
            break
        }
    }
    
    private func aboutExited(){
        if settings.useNonPersonalizedAds == showMeRelevantAds {
            isAdReloadRequired = true
        }
        settings.useNonPersonalizedAds = !showMeRelevantAds
    }
}
