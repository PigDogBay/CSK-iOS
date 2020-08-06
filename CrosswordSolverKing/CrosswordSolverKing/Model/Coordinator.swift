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
    case Splash, Main, About, Filter, Help
}

///Deals with interactions between views and holds shared observed variables
class Coordinator : ObservableObject {
    let model : Model
    let ratings : Ratings
    let mainVM : MainViewModel
    let settings : Settings

    @Published var showMeRelevantAds = true
    @Published var isAdReloadRequired = false

    private var showMePressed = false
    private var showMeExample = ""


    init(){
        model = Model()
        ratings = Ratings(appId: Strings.appId)
        mainVM = MainViewModel(model: model)
        settings = Settings()
        showMeRelevantAds = !settings.useNonPersonalizedAds
    }

    func showHelpExample(example : String){
        showMePressed = true
        showMeExample = example
    }

    func onAppear(screen : AppScreens){
        switch screen {
        case .Splash:
            break
        case .Main:
            mainEntered()
        case .About:
            break
        case .Filter:
            break
        case .Help:
            break
        }
    }
    
    func onDisappear(screen : AppScreens){
        switch screen {
        case .Splash:
            break
        case .Main:
            break
        case .About:
            aboutExited()
        case .Filter:
            break
        case .Help:
            break
        }
    }
    
    private func aboutExited(){
        if settings.useNonPersonalizedAds == showMeRelevantAds {
            isAdReloadRequired = true
        }
        settings.useNonPersonalizedAds = !showMeRelevantAds
    }
    
    private func mainEntered(){
        if showMePressed {
            showMePressed = false
            model.query = showMeExample
        }
    }
}
