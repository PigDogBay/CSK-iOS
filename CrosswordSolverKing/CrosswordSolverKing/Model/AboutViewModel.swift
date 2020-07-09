//
//  AboutViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine

class AboutViewModel : ObservableObject {
    @Published var showMeRelevantAds = true
    
    init(){
        let settings = Settings()
        showMeRelevantAds = !settings.useNonPersonalizedAds
    }
    
    func showLegal(){
    }
    
    func showPrivacyPolicy(){
        UIApplication.shared.open(URL(string: Model.privacyURL)!, options: [:])
    }
    
    func showGooglePrivacyPolicy(){
        UIApplication.shared.open(URL(string: "https://www.google.com/policies/technologies/partner-sites/")!, options: [:])
    }
    
    func recommend(){
    }
    
    func feedback() {
    }
    
    func rate(){
    }

    func viewDisappear() {
        let settings = Settings()
        settings.useNonPersonalizedAds = !showMeRelevantAds
    }
    
}
