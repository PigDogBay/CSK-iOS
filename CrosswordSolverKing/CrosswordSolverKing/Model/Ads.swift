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
            "0200fa505875358d7e2d07bc993bd27f",//iPad
            "0ead52ca5eafcbe25f3b929cda2cdbf1"//iPod Touch
           ]
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
