//
//  EUConsent.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation

class EUConsent : ObservableObject{
    @Published var showEUConsent = true
    @Published var showAdChoice = true
    
    func personalizedAds(){
        showEUConsent = false
    }
    
    func nonPersonalizedAds(){
        showAdChoice = false
    }
    
    func back(){
        showAdChoice = true
        
    }
    func agree(){
        showEUConsent = false

    }
    
    func showPrivacyPolicy(){
            //TODO open in safari
    }

}
