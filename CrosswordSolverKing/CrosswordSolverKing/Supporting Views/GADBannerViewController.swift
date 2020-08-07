//
//  GADBannerViewController.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 22/06/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMobileAds

/*
 Based on https://stackoverflow.com/questions/57641603/google-admob-integration-in-swiftui
 
This code uses standard banner ads, adaptive banners are troublesome
  1) You need to know the screen size and orientation before loading an Ad to create the AdSize
 The SwiftUI code also needs to know what size to set for the GADBannerViewController (or its container)
 - I guess AdSizes could be computed for both landscape and portrait ads when the app starts up
 

 2) For rotations, in updateUIViewController() I guess you will need to
 - Remove old GADBannerView
 - create a new GADBannerView,
 - set the correct adsize
 - add the new banner to the VC
 
 The SwiftUI code will also need to set the frame size of the viewcontroller and this needs to be recomputed on rotation.
 
 3) It maybe best to wait for an official Admob example on how to implement Adaptive banners for SwiftUI, as making a
 work around could cause an Admob policy exception if I violate some implementation rule or I encroach into the safe area.
 
*/
struct GADBannerViewController: UIViewControllerRepresentable {

    //Need to respond to user ad preference changes made in the AboutView
    @EnvironmentObject var coordinator : Coordinator
    let gadSize : GADAdSize

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: gadSize)
        let viewController = UIViewController()
        view.adUnitID = Ads.bannerAdId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: gadSize.size)
        view.load(Ads.createRequest())
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        print("GAD Update")
        if coordinator.isAdReloadRequired {
            if uiViewController.view.subviews.count>0 {
                if let bannerView = uiViewController.view.subviews[0] as? GADBannerView {
                    print("Reloading the ad")
                    bannerView.load(Ads.createRequest())
                }
            }
            coordinator.isAdReloadRequired = false
        }
    }
}
