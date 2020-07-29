//
//  AboutViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine
import MessageUI
import SwiftUtils

class AboutViewModel : ObservableObject {
    @Published var showMeRelevantAds = true
    @Published var isAdReloadRequired = false
    @Published var result: Result<MFMailComposeResult, Error>? = nil
    @Published var isMailVCPressented = false
    @Published var showNoEmailAlert = false
    
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

    func feedback(){
        if MFMailComposeViewController.canSendMail() {
            isMailVCPressented = true
        } else if let emailUrl = mpdbCreateEmailUrl(to: Strings.emailAddress, subject: Strings.feedbackSubject, body: "")  {
            UIApplication.shared.open(emailUrl)
        } else {
            showNoEmailAlert = true
        }
    }

    func viewDisappear() {
        let settings = Settings()
        if settings.useNonPersonalizedAds == showMeRelevantAds {
            isAdReloadRequired = true
        }
        settings.useNonPersonalizedAds = !showMeRelevantAds
    }
}
