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
    @Published var isAdReloadRequired = false
    
    init(){
        let settings = Settings()
        showMeRelevantAds = !settings.useNonPersonalizedAds
    }
    
    func showPrivacyPolicy(){
        UIApplication.shared.open(URL(string: Strings.privacyURL)!, options: [:])
    }
    
    func showGooglePrivacyPolicy(){
        UIApplication.shared.open(URL(string: "https://www.google.com/policies/technologies/partner-sites/")!, options: [:])
    }
    
    func rate(){
        UIApplication.shared.open(URL(string: Strings.itunesAppURL)!, options: [:])
    }

    func viewDisappear() {
        let settings = Settings()
        if settings.useNonPersonalizedAds == showMeRelevantAds {
            isAdReloadRequired = true
        }
        settings.useNonPersonalizedAds = !showMeRelevantAds
    }
    
}
