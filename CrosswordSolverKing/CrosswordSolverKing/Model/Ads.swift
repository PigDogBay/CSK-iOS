//
//  Ads.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import SwiftUtils

class Ads : ObservableObject
{
    static let bannerAdId = "ca-app-pub-3582986480189311/9874039993"
    @Published var isAdsSetupFinished = false
    
    /**
     For testing: delete the app to show dialog
     Dialog appears only once, on queue, com.apple.root.default-qos
     Otherwise .authorized or .denied is return on main-thread
     */
    func requestIDFA() {
        if !isAdsSetupFinished {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                self.setup()
                self.isAdsSetupFinished = true
          })
        }
    }

    private func setup(){
        let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
        requestConfiguration.maxAdContentRating = .general
        //Admob SDK guide recommends removing this code for release builds
        #if DEBUG
        requestConfiguration.testDeviceIdentifiers = [
            (kGADSimulatorID),
            "0200fa505875358d7e2d07bc993bd27f",//iPad
            "0ead52ca5eafcbe25f3b929cda2cdbf1"//iPod Touch
           ]
        #endif
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    static func createRequest() -> GADRequest{
        let request = GADRequest()
        let useNpa = Settings().useNonPersonalizedAds
        if useNpa {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        return request
    }
}
