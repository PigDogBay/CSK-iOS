//
//  Ads.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct Ads
{
    static let bannerAdId = "ca-app-pub-3582986480189311/9874039993"

    static func setup(){
        let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
        //app is rated 17+, so may as well allow mature ads
        requestConfiguration.maxAdContentRating = .matureAudience
        requestConfiguration.testDeviceIdentifiers = [
            (kGADSimulatorID as! String),
            "1d0dd7e23d31eae8a3e9ad16a8c9b3b4",//iPad
            "a4b042150b6cace14cc182d6bf254d09"//iPod Touch
           ]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    static func createRequest(useNpa : Bool) -> GADRequest{
        let request = GADRequest()
        if useNpa {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        return request
    }
}
