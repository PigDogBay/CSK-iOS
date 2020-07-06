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
    
    func personalizedAds(){
        showEUConsent = false
    }
    
    func nonPersonalizedAds(){
    }
    
    func back(){
        
    }
    func agree(){
        showEUConsent = false

    }
    
    func showPrivacyPolicy(){
            //TODO open in safari
    }

}
