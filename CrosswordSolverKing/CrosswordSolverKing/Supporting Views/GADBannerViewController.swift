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
 The hard part is knowing the actual size of the adaptive banner before its displayed so that
 SwiftUI layout code can set the frame width and height
 
*/
struct GADBannerViewController: UIViewControllerRepresentable {

    //Need to respond to user ad preference changes made in the AboutView
    @EnvironmentObject var coordinator : Coordinator
    
    func makeUIViewController(context: Context) -> UIViewController {
        let bannerSize = GADBannerViewController.getAdBannerSize()
        let viewController = UIViewController()
        let banner = GADBannerView(adSize: bannerSize)
        banner.adSize = bannerSize
        banner.adUnitID = Ads.bannerAdId
        banner.rootViewController = viewController
        viewController.view.addSubview(banner)
        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
        banner.load(Ads.createRequest())
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        if coordinator.checkAdReloadRequired() {
            if uiViewController.view.subviews.count>0 {
                if let banner = uiViewController.view.subviews[0] as? GADBannerView {
                    //resize incase orientation has changed
                    let bannerSize = GADBannerViewController.getAdBannerSize()
                    banner.adSize = bannerSize
                    uiViewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
                    banner.load(Ads.createRequest())
                }
            }
        }
    }
    
    /*
        An adaptive banner's size is based on the screen width, this calculates the safe area screen width
        and then uses this to calculate the banner size.
        This function is also called by the SwiftUI code.
     */
    static func getAdBannerSize() -> GADAdSize {
        if let rootView = UIApplication.shared.windows.first?.rootViewController?.view {
            let frame = rootView.frame.inset(by: rootView.safeAreaInsets)
            return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        }
        //No root VC, use 320x50 ad banner
        return kGADAdSizeBanner
    }
}
