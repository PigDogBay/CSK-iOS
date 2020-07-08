//
//  EUConsent.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit

class EUConsent : ObservableObject{
    @Published var showEUConsent : Bool
    @Published var showAdChoice = true
    
    init() {
        let settings = Settings()
        showEUConsent = settings.showEUConsentDialog
    }
    
    func personalizedAds(){
        showEUConsent = false
        saveSettings(showNonPersonalized: false)
    }
    
    func nonPersonalizedAds(){
        showAdChoice = false
    }
    
    func back(){
        showAdChoice = true
        
    }
    func agree(){
        showEUConsent = false
        saveSettings(showNonPersonalized: true)
    }
    
    private func saveSettings(showNonPersonalized : Bool){
        let settings = Settings()
        settings.showEUConsentDialog = false
        settings.useNonPersonalizedAds = showNonPersonalized
    }
    
    
    func showPrivacyPolicy(){
        UIApplication.shared.open(URL(string: Model.privacyURL)!, options: [:])
    }

}
